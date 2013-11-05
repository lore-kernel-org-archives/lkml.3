Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab3KETPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:15:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab3KETPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:15:11 -0500
Date: Tue, 5 Nov 2013 14:14:59 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>, toshi.okajima@jp.fujitsu.com,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, eparis@redhat.com,
        linux-audit@redhat.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
Message-ID: <20131105191459.GF24236@madcap2.tricolour.ca>
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com>
 <5271D3FC.8000709@cn.fujitsu.com>
 <5278A39B.6000303@cn.fujitsu.com>
 <5278A3D5.3010309@cn.fujitsu.com>
 <5278A828.50406@huawei.com>
 <5278B2D7.6060409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278B2D7.6060409@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 04:56:55PM +0800, Gao feng wrote:
> On 11/05/2013 04:11 PM, Li Zefan wrote:
> > On 2013/11/5 15:52, Gao feng wrote:
> >> On 11/05/2013 03:51 PM, Gao feng wrote:
> >>> Ping...
> >>
> >> I want to catch up the merge window..
> > 
> > Even if your patches are accepted by a certain maintainer immediately,
> > he will in no doubt queue them for 3.14.
> 
> Yes, you are right...
> But I still want to get some comments..

Definitely won't make it in in this merge window.  I agree it needs
discussion, but I won't start that for at least another week (I'm
currently at IETF in Vancouver.).


- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
