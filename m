Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaG1UNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:13:49 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:60733 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1UNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:13:48 -0400
Date: Mon, 28 Jul 2014 22:13:44 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Subject: Re: Bug on Kernel 3.16 r6: Sound and Buffering in Clementine with
 Files are Transferring to Music Directory
Message-ID: <20140728201344.GB13832@fancy-poultry.org>
References: <CAPDOMViYi_rg_cGp_SgZVqX6pw+SB=CVbr1kFn5WG481s4tz5A@mail.gmail.com>
 <20140727083758.GA4834@fancy-poultry.org>
 <CAPDOMVgjLU+r82eKFA=4-v_oS+4c4fCtovcZMer5x5GAW56DSw@mail.gmail.com>
 <20140728095442.GA4875@fancy-poultry.org>
 <CAPDOMViPdBnkLH2t=1zGAyB98bNGfZrxLvDngDrDQHYP+uCuqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDOMViPdBnkLH2t=1zGAyB98bNGfZrxLvDngDrDQHYP+uCuqg@mail.gmail.com>
Organization: private site
OpenPGP: id=60F4A92C; url=http://www.fritha.org/htd.asc;
 preference=signencrypt
X-Mailer: Mew version 6.6 on Emacs 24.3.1 / Mule 6.0 (HANACHIRUSATO)
X-Provags-ID: V02:K0:JbPGxYV20l+UCLy1MgYJ6mAw/vkwrj4fRaKuZrvqm4r
 laV1u5Yw3hJZ/F9uV0WvolX0wKX/WzcwX5rBZjCavDk3vkovR8
 IO9r6wXWSaXMsV1Uytrl9h7siMAL8TiGcYWyf2fAJeZK+hjTrS
 qAYFaD6/1ub2NWcfbzcboX4pRG4LyglaEEHmctsoZSWQ46PY60
 WTzLYldhn+tVj/SNW1XnOumLNh/35xxuDBm/CZVv3YuBsf/VV8
 fEoxfLBYWlAXPugjOD8vXwoTL7CZgccj7UlZcT829nZq7irZSm
 gumF730C2XuzWXRcp9zcvfUiejXP3tnNsjAhFhfpXzP2D5P3jg
 TBDvzr8t1eKJJTR5Kebs7EuWCJD8Z0XBZGyygEWsU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.07.2014, Nick Krause wrote: 

> Then explain to me why this is only happening on recent rc kernels and not
> the Ubuntu distro kernels I was using before. Seems weird that only
> recent rc kernels are triggering this.

The, if you actually can reproduce it with a vanilla kernel (non-
distro) and you're still convinced it must be a bug, you could
consider bisecting the offending patch. Here is how it works:

http://tinyurl.com/yo533k

Good luck!



