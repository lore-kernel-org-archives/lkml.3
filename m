Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbbAZHxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 02:53:53 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41460 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbbAZHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 02:53:50 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH] Input: atmel_mxt_ts - implement T100 touch object support
Date: Mon, 26 Jan 2015 08:53:39 +0100
Message-Id: <1422258820-4236-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <54943E99.5060206@itdev.co.uk>
References: <54943E99.5060206@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nick,

On 12/19/2014 15:04 PM, Nick Dyer wrote:>
> Hi Benson-
> On 18/12/14 18:49, Benson Leung wrote:
>> Dmitry and Chung-Yih have had some discussion about how to handle
>> hovering fingers, and I think the direction they wanted to go was to
>> use ABS_MT_DISTANCE instead.
>> 
>> http://www.spinics.net/lists/linux-input/msg33950.html
>
> Thanks for flagging this up. The patch I submitted is written against the
> Android touch devices spec, which treats ABS_MT_PRESSURE being zero as
> hover, but indeed currently the handling of BTN_TOUCH when using
> input_mt_report_pointer_emaultion() won't be quite right.
> 
> I will have a look at straightening this out and re-post.

Are you planning to send your patch using ABS_MT_DISTANCE for 3.20?

If not, I can take a look since T100 support is needed for the Samsung
Peach Pi Chromebook.

Best regards,
Javier
