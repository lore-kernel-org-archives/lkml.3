Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaIEVq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 17:46:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44866 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbaIEVqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 17:46:53 -0400
X-Sasl-enc: 8KjUD6UAJCPWHSq9WFSIVHrB9vfCPKm6Rjj/I62osI7q 1409953612
Date: Fri, 5 Sep 2014 14:46:52 -0700
From: Greg KH <greg@kroah.com>
To: Francis Moreau <francis.moro@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Peter Kieser <peter@kieser.ca>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [GIT PULL] bcache changes for 3.17
Message-ID: <20140905214652.GB30221@kroah.com>
References: <20140805043346.GF541@moria.home.lan>
 <53E10D48.1010700@kernel.dk>
 <53E7251B.3080305@kieser.ca>
 <540966BA.9030106@gmail.com>
 <5409C5FC.6020406@kernel.dk>
 <5409CC3D.7040009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5409CC3D.7040009@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 04:44:13PM +0200, Francis Moreau wrote:
> On 09/05/2014 04:17 PM, Jens Axboe wrote:
> > 
> > We need to do something about this. From this latest pull, looks like
> > all should go to stable:
> > 
> > 5b1016e62f74c53e0330403025954c8d95384c03
> > 9aa61a992acceeec0d1de2cd99938421498659d5
> > dbd810ab678d262d3772d29b65844d7b20dc47bc
> > 8b326d3a2a76912dfed2f0ab937d59fae9512ca2
> > e5112201c1285841f8b565ece5d6ae7e0d7947a2
> > a664d0f05a2ec02c8f042db536d84d15d6e19e81
> > c5aa4a3157b55bdca18dd2a9d9f43314470b6d32
> > 9e5c353510b26500bd6b8309823ac9ef2837b761
> > bcf090e0040e30f8409e6a535a01e6473afb096f
> > 501d52a90cbe652b41336c206ff0e95799d5a9b5
> > 8e0948080670f6330229718b15a6a1a011d441ce
> > 60ae81eee86dd7a520db8c1e3d702b49fc0418b5
> > 913dc33fb2720fb5f979011664294137ddd8b13b
> > 6b708de64adb6dc8319e7aeac922b46904fbeeec
> > 400ffaa2acd72274e2c7293a9724382383bebf3e
> > d83353b319d47ef8cce82467da6a25c2d558253f
> > bf0c55c986540483c34ca640f2eef4c3314388b1
> > c9a78332b42cbdcdd386a95192a716b67d1711a4
> > 2452cc89063a2a6890368f185c4b6d7d8802175b
> > 25abade29616d42d60f9bd5e6a5ad07f7314e39e
> > 5b25abade29616d42d60f9bd5e6a5ad07f7314e3
> > 789d21dbd9d8889e62c79ec19585fcc97e42ef07
> > 0781c8748cf1ea2b0dcd966571103909528c4efa
> > 
> > (from oldest to newest). And that's just from 3.16 to 3.17-rc3, going
> > all the way back to 3.10 would be a lot of work. If there's anyone that
> > cares about bcache on stable kernels (and actually use it), now would be
> > a good time to pipe up.
> > 
> 
> Then if it's too much work, it just confirmed what was asked previously:
> bcache is still experimental so mark it such for stable kernels.

You seem to have a misunderstanding of just exactly what the stable
kernels are, and what they are for.  See my other email for details.

greg k-h
