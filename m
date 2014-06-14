Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbaFNWzh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:55:37 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:34086 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaFNWzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:55:36 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Monam Agarwal <monamagarwal123@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ced1401: userspace: use1401.c:  Cleaning up if statement that always evaluates to true 
Date: Sun, 15 Jun 2014 00:56:31 +0200
Message-Id: <1402786592-13308-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This if statement that always evaluates to true.
Unsigned variable can't be negative so it is unnecessary to test it.
This can of course also mean that there is a problem with this error test is 0 bytes an error?

This was found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  staging: ced1401: userspace: use1401.c:  Cleaning up if statement that always evaluates to true

 drivers/staging/ced1401/userspace/use1401.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

-- 
1.7.10.4

