Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaIIOvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:51:00 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:20380 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbaIIOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:50:58 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: atmel_mxt_ts fixes
Date: Tue,  9 Sep 2014 15:50:47 +0100
Message-Id: <1410274249-3469-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry/Stephen-

I have tested and reworked the fix for the double free issue in atmel_mxt_ts
that Stephen identified. A lot more entertaining than I thought at first. Also
a minor change to reduce the verbosity of a warning message.

cheers

Nick

