Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab3BSSo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:44:29 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58707 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3BSSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:44:26 -0500
Date: Tue, 19 Feb 2013 10:44:22 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chung-Yih Wang =?utf-8?B?KOeOi+W0h+aHvyk=?= <cywang@google.com>
Cc: li guang <lig.fnst@cn.fujitsu.com>, linux-input@vger.kernel.org,
        Tai-hwa Liang <avatar@sentelic.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Paul Fox <pgf@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: psmouse - retry getid command in psmouse_probe()
Message-ID: <20130219184422.GA21103@core.coreip.homeip.net>
References: <1351678279-32615-1-git-send-email-cywang@chromium.org>
 <1361179560.7859.5.camel@liguang.fnst.cn.fujitsu.com>
 <CAM2ehZZ9LyTkG+qi_ihGzYJn2fB=s9RCLT67ThZUB9mmyQSzhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM2ehZZ9LyTkG+qi_ihGzYJn2fB=s9RCLT67ThZUB9mmyQSzhw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chung-yih,

On Mon, Feb 18, 2013 at 05:45:07PM +0800, Chung-Yih Wang (王崇懿) wrote:
> Yes, I could add CONFIG_MOUSE_PS2_SYNAPTICS for the change as we only
> need it for synaptics touchpad/touchpoint on lenovo's machines.
> 

I do not think it will solve anything as all distributions have
CONFIG_MOUSE_PS2_SYNAPTICS enabled.

Could you tell me what the response is to the initial GETID command that
you see on these laptops?

Thanks.

-- 
Dmitry
