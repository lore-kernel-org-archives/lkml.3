Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaCWUD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 16:03:56 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36026 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750942AbaCWUDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 16:03:55 -0400
Date: Sun, 23 Mar 2014 20:03:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jean-Francois Moine <moinejf@free.fr>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/i2c: tda998x: Change the compatible strings
Message-ID: <20140323200334.GP7528@n2100.arm.linux.org.uk>
References: <20140321115541.01cbbb06@armhf> <532C40B0.3000805@gmail.com> <20140323111903.51c73c82@armhf> <532F23F5.6020001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532F23F5.6020001@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 07:12:05PM +0100, Sebastian Hesselbarth wrote:
> On 03/23/2014 11:19 AM, Jean-Francois Moine wrote:
>> On Fri, 21 Mar 2014 14:37:52 +0100
>> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>>>>    Required properties;
>>>> -  - compatible: must be "nxp,tda998x"
>>>> +  - compatible: may be "nxp,tda9989", "nxp,tda19988" or "nxp,tda19989"
>>>
>>> There is a "DT is ABI" policy and although there is no mainline Linux
>>> user of current compatible, the correct way would be to deprecate
>>> "nxp,tda998x" and introduce new compatibles.
>>
>> Pratically, what is this way?
>
> Currently, there is no effective way to deprecate a binding or
> compatible. You just add the one(s) that are more sensible and
> you mark the old one as DEPRECATED by simply writing it in the
> binding doc.
>
> The driver should support the old binding at least for a while.

It doesn't need to - it's only been in development trees so far, and
never been in a mainline full release.  Until it does, the binding
does not become stable.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
