Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaLSPFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:05:06 -0500
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:12345 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbaLSPFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:05:04 -0500
Message-ID: <54943E99.5060206@itdev.co.uk>
Date: Fri, 19 Dec 2014 15:04:57 +0000
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Benson Leung <bleung@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Chung-yih Wang <cywang@chromium.org>
Subject: Re: [PATCH] Input: atmel_mxt_ts - implement T100 touch object support
References: <1418156167-11724-1-git-send-email-nick.dyer@itdev.co.uk> <CANLzEktMgEDTu4SpNasO3A_bsLWd5QEKkmJ9FdHd3v9xamNn0Q@mail.gmail.com>
In-Reply-To: <CANLzEktMgEDTu4SpNasO3A_bsLWd5QEKkmJ9FdHd3v9xamNn0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson-

On 18/12/14 18:49, Benson Leung wrote:
> Dmitry and Chung-Yih have had some discussion about how to handle
> hovering fingers, and I think the direction they wanted to go was to
> use ABS_MT_DISTANCE instead.
> 
> http://www.spinics.net/lists/linux-input/msg33950.html

Thanks for flagging this up. The patch I submitted is written against the
Android touch devices spec, which treats ABS_MT_PRESSURE being zero as
hover, but indeed currently the handling of BTN_TOUCH when using
input_mt_report_pointer_emaultion() won't be quite right.

I will have a look at straightening this out and re-post.

cheers

Nick
