Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbaIBPb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:31:59 -0400
Received: from cernmx11.cern.ch ([188.184.36.50]:23783 "EHLO CERNMX11.cern.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666AbaIBPb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:31:58 -0400
From: Federico Vaga <federico.vaga@cern.ch>
To: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <industrypack-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
Subject: IPACK - ipack and ipoctal improvements 
Date: Tue, 2 Sep 2014 17:31:38 +0200
Message-ID: <1409671901-4009-1-git-send-email-federico.vaga@cern.ch>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.138.193.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tested these patches only on kernel 3.2 and 3.6 because I cannot easly
test them on the next branch. I think that there are not important
modification in the kernel that can affect the behave of these patches.

