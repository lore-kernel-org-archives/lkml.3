Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbaCQRdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:33:31 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:45175 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbaCQRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:27 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 13:33:27 EDT
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: [PATCH 00/22] atmel_mxt_ts patches, already signed-off
Date: Mon, 17 Mar 2014 17:26:33 +0000
Message-Id: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dimitry-

Here is a set of patches for atmel_mxt_ts that you've already signed-off. I've
rebased them against the most recent mainline and made some very minor changes
such as INIT_COMPLETION->reinit_completion.

thanks

Nick Dyer

