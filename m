Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaAPFyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 00:54:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60535 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbaAPFyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 00:54:18 -0500
Message-ID: <52D773F7.7000108@zytor.com>
Date: Wed, 15 Jan 2014 21:53:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, mingo@kernel.org,
        hpa@linux.intel.com
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86, apic: Make disabled_cpu_apicid static read_mostly,
 fix typos
References: <20140115182511.GA22737@gmail.com> <tip-5b4d1dbc24bb6fd7179ada0f47be34e27e64decb@git.kernel.org> <52D763BC.8050909@jp.fujitsu.com>
In-Reply-To: <52D763BC.8050909@jp.fujitsu.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 08:44 PM, HATAYAMA Daisuke wrote:
> 
> This is not typo in my intention.
> 
> generic_processor_info() has two more cases where it ignores cpus.
> In either cases, printed messages are tagged with "ACPI" because this
> function is called when parsing ACPI MADT table in acpi_boot_init();
> this function is also being used to parse other kind of tables but
> the "ACPI" tag would mean that the function was first for ACPI only.
> 

But it has nothing to do with ACPI -- it is an APIC ID from the command
line -- so that would be actively misleading.

	-hpa


