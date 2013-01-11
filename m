Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab3AKG5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 01:57:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:55166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab3AKG5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 01:57:44 -0500
Date: Fri, 11 Jan 2013 07:57:38 +0100
From: Heinz Diehl <htd@fancy-poultry.org>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm intel fixes
Message-ID: <20130111065738.GB27583@fancy-poultry.org>
References: <alpine.DEB.2.00.1301102155250.6541@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1301102155250.6541@skynet.skynet.ie>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+116 (b0265d385207) (2011-07-01)
X-Provags-ID: V02:K0:Rby2DNM2nl4DKawHAPLA5fGGisxnTJ65ygaUf8LrNX/
 LH2BAnyrkFExx3KYJ6fm49m9C4FXxA/HWgJQWmGKNYFP8Psqye
 O59/1NtDOBzHgYnfTmuhuqOq3uVaItPXDkfcxKRb0QfDwUeo2D
 RTCDl57MN9hawQkB+IS/0ZWkZb7Xjm6dG/9TmpLx/1I5sbuzh6
 Ck26Lgpl+f2AGdbjlsnUU1d3B5xYBVtiVW3fhlhov4OPGYWX/D
 KUNNqbAcCNgxbZA7rHO8MMo4FDGnJDuEX712WYrOuyAIZ/bB71
 6Km3AoXSKgUomGQo8KRm8QzdCaB7pgORA/xetHEkYq9dWsYZOQ
 jtTabnGlr6M8Jjih2H+g5MtDuAIzXkpqhqd5zmBtX
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.01.2013, Dave Airlie wrote: 

> Just intel fixes, including getting the Ironlake systems back to the state 
> they were in for 3.6.

>       drm/i915: Revert shrinker changes from "Track unbound pages"

I guess it's this one which fixes the ILK hang. Would it be enough for
3.7 to just appy this patch to get the problem fixed?

