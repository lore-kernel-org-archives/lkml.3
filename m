Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3KXVES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 16:04:18 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43353 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3KXVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 16:04:14 -0500
Message-ID: <529269CC.3050007@kernel.org>
Date: Sun, 24 Nov 2013 21:04:12 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, Sebastian Reichel <sre@debian.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH v2] itg3200: add dt support.
References: <20131119113013.39dae3cd@notabene.brown>	<20131119014938.GA20782@earth.universe> <20131119164839.7cd3f4f1@notabene.brown>
In-Reply-To: <20131119164839.7cd3f4f1@notabene.brown>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/19/13 05:48, NeilBrown wrote:
> On Tue, 19 Nov 2013 02:49:38 +0100 Sebastian Reichel <sre@debian.org> wrote:
> 
>> Hi,
>> 
>> On Tue, Nov 19, 2013 at 11:30:13AM +1100, NeilBrown wrote:
>>> No new configuration, just a 'compatible' string and documentation.
>> 
>> itg3200 looks like a candidate for the list of trivial i2c devices [0] to me.
>> 
>> [0] Documentation/devicetree/bindings/i2c/trivial-devices.txt
>> 
>> -- Sebastian
> 
> Hmmm... a file that isn't referenced anywhere else in the kernel documentation so is unlikely to be found except by
> people who know it is there....
> 
> I can see that having lots of files for trivial devices is rather clumsy, but there must be a better way. I don't
> suppose we could just put the documentation in the device-driver file in some format similar to kernel-doc and just
> extract it if it is wanted separately?  I think people read code a lot more than they read documentation. I know I
> do.
> 
> But I can re-send with an update to trivial-devices.txt is that is what is wanted.
Given that typically people will need to grep for the name of the actual
device they have to find the docs (not always obvious where in the documentation
their bindings will lie), it perhaps makes sense to put these simple devices
in trivial-devices.txt.

Anyhow, it is how it is currently done and we can always unwind it later to separate
files so, yes - please do move this and if missing add the invense entry as well
as Mark has requested.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSkmnMAAoJEFSFNJnE9BaI2QQP/R9wloBWmMKiuF+2MFD4qPSM
GCgKVVptzk/qgV1TYvj7OsuYigGkCcVdTptRg3uDgrg2gL/1beYz8HqbeIRALcCp
G2rPKhFGF9R6LalHUU0eMVGvvTqUe7J2gXCnxoINp0QM+fAyFfkMk5FZJJur4drI
GnwroRToRcrIRloIFNstDc5m5/jphshCB++sEDh/uTZT64ZcH5VKlcsHmuzMGOEm
VO/gebr5kHogGA54HUB4C8psrMJncKm3XFt57yq9tkhHkDk/VijDdROuhbOMY/K0
6eLLl7oIUkYtQ0AOowg2pDG3B5mvBexfi2W5JWf9yxiK/GBE54OQwyPNXWSeR4Jo
yLFs+anAtoNVYJuX5O0hs5NXzAJCAhcsXVggzKAmBY5IQkUZ5HzyBxwpH7aB1c1N
xZY89s1gx4Fke3GNPxqQ7tTDnFy5qZvnZ1/RM0F1j6D6zVMVSM5rRtjZrn3jdpue
gvzoYSV7f6la+BVj6S2tR2bEFkEssiaUkPn844e+EPZ+iSt8rLVD7WRA0M7bVp4t
R5ruRioF7D3LGzSfJwhna5/SNCytKuUBKc98PL0VZRx1707GAa2Ucl/YAIp/Gnkh
ERq9T5GbeT+9zMAfQpeE7Jaz+CwrS8ib0ul+IZzA9q+CqOdZZo3/xjdkQjSw9D9C
IL28pFxuFOKYabdZ9kQC
=EsOI
-----END PGP SIGNATURE-----
