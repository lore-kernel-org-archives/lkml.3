Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaJMQOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:14:09 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:42538 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbaJMQOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:14:07 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Cc: Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Maxime Coquelin <maxime.coquelin@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>, Harsh Gupta <harsh.gupta@st.com>
Subject: Re: [PATCH v3 6/8] phy: miphy28lp: Add SSC support for PCIE
In-Reply-To: Your message of "Mon, 13 Oct 2014 10:16:06 +0200."
             <CAG374jBJcX00S4nSugWXaUxAQV3Bwp+OxY0c2GJ-+rskzDzpGw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1411721657-9924-1-git-send-email-gabriel.fernandez@linaro.org> <1411721657-9924-7-git-send-email-gabriel.fernandez@linaro.org> <15685.1412018368@turing-police.cc.vt.edu>
            <CAG374jBJcX00S4nSugWXaUxAQV3Bwp+OxY0c2GJ-+rskzDzpGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1413216738_2444P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 13 Oct 2014 12:12:18 -0400
Message-ID: <4723.1413216738@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1413216738_2444P
Content-Type: text/plain; charset=us-ascii

On Mon, 13 Oct 2014 10:16:06 +0200, Gabriel Fernandez said:

> Concerning multiple writing in MIPHY_PLL_SBR_1, the writing of the
> first 0 it's to be sure there is no previous request.
> Then we take account new setting by writing 0x02.
> And then we make it 0 to make sure there is no other pending requests.
>
> I added comments and macro to be more clear (see the code below).

Thanks, that will be a lot clearer to some poor soul down the road who
has to delve in here (possibly to figure out if a new part can use the
same driver and/or what changes need to be made).


--==_Exmh_1413216738_2444P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVDv54gdmEQWDXROgAQJvuw//XcxedjbPlakvTdPWSdt9TgYwN8Xb7BCl
easIfbuN0h3Q2D+NmIiDTbVAcx1c3c4/NJjSXm/Z5ka95IO+maQJvXRXEVroLiAH
eVm+m2NKIqMcI8ib3OA01t1zPOAYwGXDu27fwnox86WqAtVyxWz2XyBjNhFPaCmg
SIGYCDY+aYAFeQBSskl/KtazuzmKAEJBxgt9hLoRXagu4sCkNcVUa86wGIdgLNxe
rLn7mkuo1ehhwpIOVokJw4IPoUNYHa0rHvyEFXyqQleEUoJTamzXJxi5aO8fb24S
4B0vEgTBbw1PFxKAk8wP9Etzwwsr0rHRkKXG931w9grZshA7jNQ9suOWigt8Q8lM
rOfO/XMapxcsqlISMpWrd/V9yigYOcKSwvF4DSKy6a8f2Eb3mzm7/2/fBZioFxIW
jbE1mAhSMlrcf/ZozuZ1cTYggv81oG+Qs0B+ZJmccQ4bpXDRtN3zNMbHSv5XMUyG
qJkwu6ZkLqN6uxCBjSTS/lC8xE2ok1xRs+CrsmSOdRiHkXmaFL/bVRRbp9N0OP5c
6Nbl/xUHlH7VvVV2DZXHb3B1diw+QCCbt/l+8O1hOFO9yR3kugJ+GFK2aBAmdxEY
KOFyMg63EZbsxjg7BRjXjH8vn5nurHLnTYl7eDpBdf5Pldt7S09o74N+xSyDmB8G
3Mqum6FrvZM=
=TXuC
-----END PGP SIGNATURE-----

--==_Exmh_1413216738_2444P--
