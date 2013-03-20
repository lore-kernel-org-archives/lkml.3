Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3CTWbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 18:31:44 -0400
Received: from exprod8og103.obsmtp.com ([64.18.3.86]:32798 "HELO
	exprod8og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751242Ab3CTWbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 18:31:43 -0400
X-AuditID: ac1c210f-b7f486d000000c69-bf-514a37a8a5e6
From: Chayan Biswas <Chayan.Biswas@sandisk.com>
To: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>,
        "elliott@hp.com" <elliott@hp.com>,
        Sumant Patro <Sumant.Patro@sandisk.com>
Subject: RE: Question about make_request_fn based block drivers
Thread-Topic: Question about make_request_fn based block drivers
Thread-Index: AQHOJbY+jpMRTbLTZk+zWVOZ9reTQpivISoQgAB7P4D//4vj4A==
Date: Wed, 20 Mar 2013 22:28:54 +0000
Message-ID: <E821E2F372F08945977BD15EAE588D61097E8272@SACMBXIP02.sdcorp.global.sandisk.com>
References: <20130320215838.GO30284@beardog.cce.hp.com>
 <E821E2F372F08945977BD15EAE588D61097E8222@SACMBXIP02.sdcorp.global.sandisk.com>
 <20130320222119.GP30284@beardog.cce.hp.com>
In-Reply-To: <20130320222119.GP30284@beardog.cce.hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.181.8.64]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRobxn+4Kc69Ag0c7VSyWrNrGanF51xw2
	i76vn1ktHk95xuzA4vHjzUtmj52z7rJ77Nq2k8nj8ya5AJYoLpuU1JzMstQifbsErox580wK
	lnFU/OxdydLAeIKti5GTQ0LAROLrscUsELaYxIV764HiXBxCAscZJa4cOg2WEBI4xygxe6MO
	iM0moC/RdG0dWLOIgL3Eq027wBqYBU4xSvy6+IgdJCEMlPjc/RuqyEHiyYkHjF2MHEC2k8TZ
	mTUgYRYBVYnJWyDm8ApES7yecYYZYvF2Rol/vf2sIAlOAQuJmdNOg81kBLru+6k1TCA2s4C4
	xK0n85kgrhaQWLLnPDOELSrx8vE/VpBdEgLyEtdP20GU60gs2P2JDcLWlli28DUzxF5BiZMz
	n7BMYBSbhWTqLCQts5C0zELSsoCRZRWjWHFicnFuemqBoZFecWJeSmZxtl5yfu4mRnCUKfLv
	YNw2xfwQowAHoxIPL8cTz0Ah1sSy4srcQ4wSHMxKIrzLlLwChXhTEiurUovy44tKc1KLDzEy
	cXBKNTAKcvUdljWbf+xk24lvlYKR8zdY6yvtjq7fMi3k/Puaefqbw9e42z5+/mhbwR2//owS
	Ttn3c9/NXcD/h39iQOIE6VmHzTKPRi/Usf9teMD1lM2DH9L/VrieNdVReZRlKVsR3DvhtfXX
	ip95UxknbW15u+S86zPj3cfMz2ketjBaaBQbrZ+tp7pHiaU4I9FQi7moOBEA8Ws9AZACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

> > I am going to push the changes to github.
>
> Great!
>
> Didn't I ask you before if the nvme drive and the sop drive were the same
> size? ;-)

[CB] Right! But the value returned by the FW was same, and the utilities round that off to 400GB in both cases. So to me it was the same size....
The devil is in the details :-(

Thanks,
Chayan



________________________________

PLEASE NOTE: The information contained in this electronic mail message is intended only for the use of the designated recipient(s) named above. If the reader of this message is not the intended recipient, you are hereby notified that you have received this message in error and that any review, dissemination, distribution, or copying of this message is strictly prohibited. If you have received this communication in error, please notify the sender by telephone or e-mail (as shown above) immediately and destroy any and all copies of this message in your possession (whether hard copies or electronically stored copies).

