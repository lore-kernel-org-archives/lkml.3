Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3LEUD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:03:58 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:40098 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3LEUDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:03:54 -0500
Message-ID: <52A0DC28.1040001@gmail.com>
Date: Thu, 05 Dec 2013 14:03:52 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/2] cpufreq: enable ARM drivers on arm64
References: <1386202994-30784-1-git-send-email-robherring2@gmail.com> <1386202994-30784-2-git-send-email-robherring2@gmail.com> <20131205181606.GY29268@sirena.org.uk>
In-Reply-To: <20131205181606.GY29268@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/05/2013 12:16 PM, Mark Brown wrote:
> On Wed, Dec 04, 2013 at 06:23:13PM -0600, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>> 
>> Enable cpufreq and power kconfig menus on arm64 along with arm
>> cpufreq drivers. The power menu is needed for OPP support. At
>> least on Calxeda systems, the same cpufreq driver is used for arm
>> and arm64 based systems.
> 
> If this needs any revisions (I'd be surprised but...) can you
> please keep me on the CCs?  I intend to pull this into LSK if
> that's OK since I was about to do roughly the same thing for it and
> upstream the result.

Will do, but I'm surprised we're at the point on arm64 of needing LSK.
There's a couple of subsystems that need enabling. I've posted EDAC
patches (need to send v3). cpuidle is another. Probably some more I
haven't looked at.

Rob

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSoNwoAAoJEMhvYp4jgsXiZmMH/0h6Zubjcqhkrx/UGYa47j7r
EU0stg3/sJvyNGlo+jDV7ljEEtHVmJyxINORDFCGBlYLnsVisYLY9Q+YRZH7PSrJ
O7eloK2LdceYabpoe0QFBXuB+VQ5uUiVH5ts9I3JLp3bxvBwjjM6rsYdKHwx4VHp
IAkCgRZZAC9WLi+F4vteC9oh+S5UoXIKpTr1ei/y21czZ6Gw8tGhrGX4fc3IcFSy
4OPFb41/RQkJL5U4KCRUrMS+8wOmJy3rLcTvjxXz85b5ht9+i01AUt6yN9mwGrjp
a/Y5pFzADIXvhlJDYt4KBK+xgYyL6keWSc2cQyW08MhyNRjr2qXzOaw3qb3VvhI=
=SJ+q
-----END PGP SIGNATURE-----
