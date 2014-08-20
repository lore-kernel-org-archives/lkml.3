Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaHTHeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 03:34:13 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:43866 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHTHeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 03:34:12 -0400
Message-ID: <53F44F49.9050000@ladisch.de>
Date: Wed, 20 Aug 2014 09:33:29 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
References: <1408466497-25640-1-git-send-email-dmitry.torokhov@gmail.com>
In-Reply-To: <1408466497-25640-1-git-send-email-dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Gameport support hasn't been working well ever since cpufreq became
> mainstream

Back in the gameport-mainstream days, we did not have a usable high-
resolution timer API.  But why can't we use something like
getrawmonotonic() now?  (Yes, I'm volunteering ...)

> and it becomes increasingly hard to find hardware and software that
> would run on such old hardware.

I have two such sound cards, and a joystick.


Regards,
Clemens
