Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422675Ab3LTNv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 08:51:59 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37550 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422654Ab3LTNv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 08:51:58 -0500
From: Michael Hoefler <michael.hoefler@studium.uni-erlangen.de>
To: michael.hoefler@studium.uni-erlangen.de
Cc: linux-kernel@i4.cs.fau.de, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Kohl <christoph.kohl@t-online.de>,
        Rupert Muchembled <rupert@rmuch.net>, Chad Williamson <chad@dahc.us>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 0/3] staging: silicom: fix code styling according to checkpatch
Date: Fri, 20 Dec 2013 14:51:10 +0100
Message-Id: <1387547475-7135-1-git-send-email-michael.hoefler@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes most issues discovered by checkpatch. That includes
whitespaces, indentation, the wrong use of parenthesis and some more. Please
refer to the specific patch description to get more details.

Besides some minor issues not discovered by checkpatch are fixed. E.g. i moved some empty lines for a better readability and added missing braces.

This series does not perform functional changes to the code because i do not
have any hardware to test it.


Michael Hoefler (3):
  silicom: fix whitespace issues in bypass.c
  silicom: fix coding style issues in bypass.c
  silicom: remaining checkpatch issues in bypass.c

 drivers/staging/silicom/bypasslib/bypass.c | 158 ++++++++++++++++-------------
 1 file changed, 85 insertions(+), 73 deletions(-)

-- 
1.8.1.2

