Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbaEMDPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:15:48 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37184 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbaEMDPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:15:46 -0400
Message-ID: <53718E5F.7050300@linaro.org>
Date: Mon, 12 May 2014 20:15:43 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: lasaine@lvk.cs.msu.su, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ntp: make is_error_status() use its argument
References: <20140513030144.32557.qmail@ns.horizon.com>
In-Reply-To: <20140513030144.32557.qmail@ns.horizon.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 08:01 PM, George Spelvin wrote:
>> CONFIG_NTP_PPS not CONFIG_SMP, right?
> D'oh, yes.  I just noticed that there were two versions and one was
> broken.  Somehow my search for the enclosing #ifdef was completely broken.
> (I could swear I saw CONFIG_SMP, but looking now it's not even mentioned
> in the file; maybe I switched editor windows?)

No worries. :)

>
>> Adding Alexander since he submitted the pps logic.
> Thank you; some of these issues of code provenance and "who the heck do
> I notify about this?" are a bit laborious to infer even with the help
> of the git logs.
tig blame <filename> is pretty amazing for this sort of thing.

thanks
-john

