Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaEUPv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 11:51:56 -0400
Received: from gproxy5-pub.mail.unifiedlayer.com ([67.222.38.55]:37004 "HELO
	gproxy5-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751148AbaEUPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 11:51:55 -0400
X-Authority-Analysis: v=2.1 cv=CpMsLBID c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=0DW4I6zegQAA:10 a=neHJxMmKCwgA:10 a=IkcTkHD0fZMA:10
 a=wCmvBT1CAAAA:8 a=djd9j7hWnewA:10 a=3mQisGbx5lUA:10 a=uP1ucDPQAAAA:8
 a=zVnsgUWF77Pmevjx42AA:9 a=QEXdDO2ut3YA:10 a=OKkzaeKiTKEA:10 a=O7Lrp-u0rTQA:10
Message-ID: <1400687490.15260.3.camel@slavad-CELSIUS-H720>
Subject: Re: [PATCH 1/1] fs/hfsplus/bnode.c: replace min/casting by min_t
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Date: Wed, 21 May 2014 19:51:30 +0400
In-Reply-To: <20140515190121.986e8999c2f305086106db86@skynet.be>
References: <20140515190121.986e8999c2f305086106db86@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.124 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

On Thu, 2014-05-15 at 19:01 +0200, Fabian Frederick wrote:
> Also fixes some pr_ formats
> 

Sorry, I was in business trip.

As I can see, there are additional three places with bad formatting of
pr_err() and hfs_dbg():
(1) http://lxr.free-electrons.com/source/fs/hfsplus/extents.c#L441
(2) http://lxr.free-electrons.com/source/fs/hfsplus/super.c#L135
(3) http://lxr.free-electrons.com/source/fs/hfsplus/xattr.c#L71

Thanks,
Vyacheslav Dubeyko.


