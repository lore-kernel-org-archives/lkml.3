Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab3BTWg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:36:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59624 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3BTWgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:36:25 -0500
Message-ID: <51254F57.7060603@zytor.com>
Date: Wed, 20 Feb 2013 14:33:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, alan@linux.intel.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Subject: Re: [PATCH V5 4/5] drivers/amba: add support for a PCI bridge
References: <cover.1361393832.git.rubini@gnudd.com> <52b9f4e1cc04b7c656e10ee16020090601f6f537.1361393832.git.rubini@gnudd.com> <20130220222419.GX17833@n2100.arm.linux.org.uk>
In-Reply-To: <20130220222419.GX17833@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 02:24 PM, Russell King - ARM Linux wrote:
> On Wed, Feb 20, 2013 at 10:24:02PM +0100, Alessandro Rubini wrote:
>> This is a PCI driver that registers AMBA devices for the range of
>> supported devices.  It is currently used by STA2X11, which exports
>> AMBA peripherals under PCIe.  The original AMBA drivers work with no
>> changes or minimal ones.
>>
>> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
>> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Alan Cox <alan@linux.intel.com>
>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>> ---
>>
>> @Russell, Alan: I repost this after rebasing, on hpa's suggestion.
> 
> I'm happy to take it through my tree if everyone is now happy with this.
> 

I am okay with that, although I would like to make sure we do a bunch of
x86 randconfigs on it before pushing it to Linus.

	-hpa

