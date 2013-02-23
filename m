Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab3BWXw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 18:52:59 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35018 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592Ab3BWXw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 18:52:57 -0500
Message-ID: <51295658.7030105@wwwdotorg.org>
Date: Sat, 23 Feb 2013 16:52:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, linux-tegra@vger.kernel.org,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [v3 0/6] ARM: tegra: convert device tree files to use CLK defines
References: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com> <1361138717.29465.2@driftwood> <5123B1F8.4040102@wwwdotorg.org> <1361649074.11282.12@driftwood>
In-Reply-To: <1361649074.11282.12@driftwood>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2013 12:51 PM, Rob Landley wrote:
> On 02/19/2013 11:10:16 AM, Stephen Warren wrote:
>> On 02/17/2013 03:05 PM, Rob Landley wrote:
>> > On 02/15/2013 02:43:11 AM, Hiroshi Doyu wrote:
>> >> Hi,
>> >>
>> >> With new dtc+cpp feature, we could get rid of magic numbers in dts*
>> >> files. This patch replaces CLK IDs.
>> >>
>> >> We also plan to share those DT header files with kernel source
>> >> later[1].
>> > ...
>> >> [1]
>> >>
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149804.html
>>
>> >>
>> >
>> > This really smells like documentation should be updated, probably
>> > booting-without-of.txt or similar. Alas, I'm not capable of writing
>> such
>> > an update...
>>
>> I'm not sure what documentation would be updated nor why. Can you
>> describe that?
> 
> "When writing new device tree files, please do not include magic
> numbers. Here's how to avoid them."
> 
> Does something in Documentation already say this somewhere?

This seems rather basic and not worth documenting. The technique is
identical to the use of header files in C/assembly/... code. I suppose
if we document that, then there would be an argument for documenting this.
