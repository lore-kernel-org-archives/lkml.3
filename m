Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab3GYTAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:00:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33115 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756360Ab3GYTAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:00:15 -0400
Message-ID: <51F1737A.9020205@wwwdotorg.org>
Date: Thu, 25 Jul 2013 11:50:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com> <20130725175702.GC22291@e106331-lin.cambridge.arm.com> <51F168FC.9070906@wwwdotorg.org> <CAOesGMiLKysW2JG1jbef76Ves=-DAYEiE9d+s8YXWRXUJ+XhaQ@mail.gmail.com>
In-Reply-To: <CAOesGMiLKysW2JG1jbef76Ves=-DAYEiE9d+s8YXWRXUJ+XhaQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:25 AM, Olof Johansson wrote:
> On Thu, Jul 25, 2013 at 11:05 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
...
>> On another related topic, something that may be useful for the DT
>> bindings reviewer team is a basic checklist for new DT bindings.
>> Something similar to Fedora's package review checklist. Perhaps also
>> (yet another?) document on a bit of DT philosophy. If this sounds
>> useful, I could try and take a stab at some basic initial version.
> 
> Sounds reasonable. Starting with one of the existing ones instead of
> from scratch is a reasonable approach. A checklist and a best
> practices doc would come a long way.

Do you have a link to an existing check-list? I know there's plenty of
best practices information out there to build on.

>> We also need to decide (or just document) exactly what "describes the
>> HW" means; see the thread on thermal limits, and consider the extension
>> of describing hard/absolute thermal limits to describing use-cased base
>> thermal profiles using the same schema, or not allowing that.
> 
> Yes indeed. A basic binding need just specify what the specific
> hardware IP is, if the rest of the configuration of the IP can be
> determined at runtime through other means (i.e. by autoprobing). It's
> stuff beyond that that gets very complicated.
> 
> To talk semi-specifics: What about USB PHY tunings for a specific
> board,

I was thinking more about the slightly blurry line between representing
HW and representing policy, but the example you gave certainly needs
consideration too.
