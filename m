Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbaHHP6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:58:13 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:63493 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756020AbaHHP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:58:11 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: Minor fixes for atmel_mxt_ts
Date: Fri,  8 Aug 2014 16:58:01 +0100
Message-Id: <1407513483-30050-1-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140807165932.GA23198@core.coreip.homeip.net>
References: <20140807165932.GA23198@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry-

I tested both your patches, here they are rebased on your current tree and
with my signoff.

I need to have a little more of a play with the change to the
input_unregister_device code before putting it it. I want to be sure that all
the possible probe failures do the sensible thing. Hopefully will get that
done early next week.

regards

Nick

