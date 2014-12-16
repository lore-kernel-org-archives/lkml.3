Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaLPAtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:49:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:39250 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750900AbaLPAtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:49:07 -0500
Message-ID: <548F80CA.8010900@ubuntu.com>
Date: Mon, 15 Dec 2014 19:46:02 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Akers, Jason B" <jason.b.akers@intel.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
CC: "Karkra, Kapil" <kapil.karkra@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>
Subject: Re: [RFC PATCH] sg3_utils: Added hybrid information log utility
References: <20141029195400.5225.96984.stgit@stg-AndroidDev-VirtualBox> <20141029195720.5225.51331.stgit@stg-AndroidDev-VirtualBox> <5473CE5C.7010300@ubuntu.com> <372C7AE269BA5E4D92B1082F530ED4B88A13F692@ORSMSX110.amr.corp.intel.com>
In-Reply-To: <372C7AE269BA5E4D92B1082F530ED4B88A13F692@ORSMSX110.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 11/25/2014 02:13 PM, Akers, Jason B wrote:
> Hi Phillip, It turns out that this patch was based on an old
> github repository that doesn't appear to be updated. Doug Gilbert
> reached out after the initial RFC and directed us to his page 
> (http://sg.danny.cz/sg/) where he has updated sg3_utils code.
> 
> As we continue to work through the feedback from our SSHD kernel 
> patches, I'm going to follow up with Doug again on sg3_utils.

So is there a set of patches that applies to a release from that web
site?  Also is the source only released as tarballs?  There is no
source repo?

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUj4DKAAoJENRVrw2cjl5RwEwH/147w+N+z9r3J70AQrLdXgtN
mRF2VLEK/v0l7rpnnyiKyL7Trjc3/YXY9tLf3feC225l9UL6K73moLKGWMI+iRU2
xvCWIJKHQyf8E/j6qFqid0G9V/IQNG9vXAZSEmrTcvT5NaEJ0U3kSCKe5w9xEYEE
6SLYTF+FRHkXceloFvW/8PAwj/2K4g/KsZShIS07kdzAh+fIoZM6qQP3XbEK5v1T
x+zuFZtIVzVglQmQWF6wAn5pBjHGNLCA1Yw1+Lx3tuJCoVv1B5ze1k0FOnWu6xOQ
bjeOQ0cgZOjYGjgywhoJn5hgKxOhfXsNsIhSSqA/SNky4vMOV5gRXKjA2WgHu6g=
=7jVR
-----END PGP SIGNATURE-----
