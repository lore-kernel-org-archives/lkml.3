Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984Ab3BVQo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 11:44:58 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:47368 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab3BVQo5 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Fri, 22 Feb 2013 11:44:57 -0500
Message-Id: <5127AED302000078000C0779@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Fri, 22 Feb 2013 16:45:55 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Greg KH" <gregkh@linuxfoundation.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Put git commit 51ac8893a7a51b196501164e645583bf78138699 on
 the stable tree please
References: <20130222154644.GB8809@phenom.dumpdata.com>
 <20130222161930.GA27694@kroah.com>
In-Reply-To: <20130222161930.GA27694@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 22.02.13 at 17:19, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Feb 22, 2013 at 10:46:45AM -0500, Konrad Rzeszutek Wilk wrote:
>> Hey Greg,
>> 
>> Please put git commit 51ac8893a7a51b196501164e645583bf78138699
>> commit 51ac8893a7a51b196501164e645583bf78138699
>> Author: Jan Beulich <jbeulich@suse.com>
>> Date:   Wed Feb 6 10:30:38 2013 -0500
>> 
>>     xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
>> 
>> on the stable tree please. It is an security errata fix and should
>> have had the CC: stable@vger.kernel.org but did not.
> 
> Thanks, what stable kernel releases should it be queued up for?

Anyone from 3.1 onwards that is still being maintained.

Jan

