Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3JaN2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 09:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752598Ab3JaN2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 09:28:34 -0400
Date: Thu, 31 Oct 2013 09:27:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: jerry.hoemann@hp.com
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, hpa@linux.intel.com,
        ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
Message-ID: <20131031132744.GB3392@redhat.com>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
 <20131022220803.GA32387@anatevka.fc.hp.com>
 <526712B2.7070108@jp.fujitsu.com>
 <20131031005812.GA15459@anatevka.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031005812.GA15459@anatevka.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 06:58:13PM -0600, jerry.hoemann@hp.com wrote:

[..]
> Daisuke,
> 
> Are you planning on making changes to the kexec tools to automate
> the setting of disable_cpu_apic to the capture kernel? Or do you
> know someone who is planning this?

I think we should not make this change in kexec-tools and should leave
it to distro scripts to append disable_cpu_apic.

Who knows in future this restriction is not there at all and kexec-tools
will be stuck with always passing disable_cpu_apic. Getting rid of
this parameter in distro scripts will be much easier.

Thanks
Vivek
