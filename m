Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3APOZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:25:19 -0500
Received: from smtp.domeneshop.no ([194.63.252.54]:39706 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3APOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:25:17 -0500
Message-ID: <50F6B868.7000304@paradoxuncreated.com>
Date: Wed, 16 Jan 2013 15:25:44 +0100
From: Ove Karlsen <ove.karlsen@paradoxuncreated.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: One last tweak for perfection.
References: <50F6B254.2020801@paradoxuncreated.com> <50F6B30F.6010207@paradoxuncreated.com>
In-Reply-To: <50F6B30F.6010207@paradoxuncreated.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/16/2013 3:02 PM, Ove Karlsen wrote:
> What kernelthreads _needs_ to run? So I can put them on max pri 
> renice, along with reniced X and app. And everything else on idle 
> priority. So to make the app run at max efficiency, and not be starved 
> by kernelthreads waiting. (Or any other consideration, for giving 
> maximal cpu to app. Even small tweaks.)
>
> To read my research so far, (and I have done much, about 2 years of 
> tweakin´ on and off.) Please see 
> http://paradoxuncreated.com/Blog/wordpress/?p=2268
>
> Main points, no highres timer, 90hz timer, + a lot of smaller tweaks. 
> This makes an amazing linux-desktop, for gaming, video and audio. The 
> popular computer for everyman. Also boosts performance, for 
> resource-constrained systems.
>
> For more advanced hacking, one could also get in there, and make 
> several HZ timers, extremely low ones, for the components who only 
> require that, and 90hz for video-components, for instance (low 
> video/frame jitter), and higher if anything should require that.
>
> Also system-wide, software should be synced to hz, if required for 
> lowest jitter, such as animations and videoplayers, and videoplayers 
> automatically change refresh rate to a multiple of video framerate.
>
> Peace Be With You.
PS: I forgot the realtime sincs of drivers. HZ is really not an issue to 
debate for me, 90 hz is sufficient, and only to userspace, right? So 
yea, forget the talk on HZ.

Peace Be With You.
