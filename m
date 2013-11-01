Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3KAAbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 20:31:42 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38241 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3KAAbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 20:31:41 -0400
Date: Fri, 1 Nov 2013 09:31:33 +0900
From: Simon Horman <horms@verge.net.au>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jerry.hoemann@hp.com, fengguang.wu@intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, bp@alien8.de,
        ebiederm@xmission.com, akpm@linux-foundation.org, hpa@linux.intel.com,
        jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131101003133.GH6818@verge.net.au>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131022220803.GA32387@anatevka.fc.hp.com>
 <526712B2.7070108@jp.fujitsu.com>
 <20131031005812.GA15459@anatevka.fc.hp.com>
 <20131031132744.GB3392@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031132744.GB3392@redhat.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:27:45AM -0400, Vivek Goyal wrote:
> On Wed, Oct 30, 2013 at 06:58:13PM -0600, jerry.hoemann@hp.com wrote:
> 
> [..]
> > Daisuke,
> > 
> > Are you planning on making changes to the kexec tools to automate
> > the setting of disable_cpu_apic to the capture kernel? Or do you
> > know someone who is planning this?
> 
> I think we should not make this change in kexec-tools and should leave
> it to distro scripts to append disable_cpu_apic.
> 
> Who knows in future this restriction is not there at all and kexec-tools
> will be stuck with always passing disable_cpu_apic. Getting rid of
> this parameter in distro scripts will be much easier.

Hi Vivek, Hi Daisuke,

That approach sounds reasonable to me.
