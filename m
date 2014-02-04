Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaBDBcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 20:32:06 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36708 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaBDBcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 20:32:03 -0500
Date: Mon, 3 Feb 2014 17:32:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sebastian Capella <sebastian.capella@linaro.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        mm-commits@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: + mm-utilc-add-kstrimdup.patch added to -mm tree
In-Reply-To: <20140204012816.22878.4159@capellas-linux>
Message-ID: <alpine.DEB.2.02.1402031730190.24053@chino.kir.corp.google.com>
References: <52ec195e.P8S/D298ZeaBLTvn%akpm@linux-foundation.org> <CACVxJT-HUXmBepz-GW3T1+ANkSxt80=1-kNFyHLdk+RRjHaWQQ@mail.gmail.com> <alpine.DEB.2.02.1402031704430.32346@chino.kir.corp.google.com> <20140204012816.22878.4159@capellas-linux>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, Sebastian Capella wrote:

> I am in the process of reworking the patches.  I'm not sure if Andrew
> was just interested in having the kstrimdup utility function available.
> 

I think the point Alexey is making is that whitespace is already stripped 
by the shell unless quoted; it seemed that you may have had a usecase 
where the string to be written would not be stripped by the shell for 
whatever reason and there was no convenient way to do it specifically for 
the file you were modifying?
