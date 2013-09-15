Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab3IONxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 09:53:16 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:54118 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab3IONxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:53:14 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <20130912183503.GB25386@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
	<20130911220228.GB15367@somewhere>
	<000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
	<20130912141625.GA23357@somewhere>
	<00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
	<20130912143137.GA23839@somewhere>
	<0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
	<20130912151102.GB23839@somewhere>
	<20130912153922.GP3966@linux.vnet.ibm.com>
	<20130912183503.GB25386@somewhere>
Date: Sun, 15 Sep 2013 16:53:12 +0300
Message-ID: <CAOtvUMc-shqH=L5PEBRumMybyaGpgVQd3w03jkA6Th6CL=E8dQ@mail.gmail.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of cpus.
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 9:35 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:

>
> Just offline the CPUs you want to isolate, affine your kthreads and re-online
> the CPUs.
>
> If you're lucky enough to have 1024 CPUs, a winter night should be enough ;-)

Great, I have 4,096 CPUs. I guess I have to wait for the winter solstice :-)

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
