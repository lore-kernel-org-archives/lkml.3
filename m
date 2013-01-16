Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab3APDi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:38:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:57085 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758107Ab3APDiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:38:24 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-dc-50f620ad6f3a
Message-id: <50F620BB.9010602@samsung.com>
Date: Wed, 16 Jan 2013 12:38:35 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, cwchoi00@gmail.com
Subject: Re: [GIT PULL] extcon for 3.8-rc4
References: <50F5067A.2060104@samsung.com> <20130115113719.GD1748@kroah.com>
 <CAGTfZH2r9TaNEPQ5am-UFwQd9t_qegxfo3MMOwJxvfctid7=-Q@mail.gmail.com>
 <20130115121356.GA2349@kroah.com>
 <CAGTfZH27VUuqqx5b4trMSDDDceWqwHE2wqPZdLbWvvBvbrzpKg@mail.gmail.com>
 <20130115134941.GA25473@kroah.com>
In-reply-to: <20130115134941.GA25473@kroah.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t8zTd21Ct8CDK5cZbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZh1q2MRV8F63YPLu8gXEHfxcjJ4eEgInEo/lH2SBsMYkL99YD
	2VwcQgLLGCXO/dnMCFN0ettrqMQiRomjNx4xQzhdTBLTWp+wgFTxCmhJNEz7wgRiswioSpxc
	NwnMZgOK739xA6ibg0NUIELiVz8HRLmgxI/J98BaRQQ0JF4evcUCMpNZ4D2jxL1LE8ASwkC9
	S7fsh9q8mEnizYP9zCCDOAX0JbbfTwCpYRbQkdjfOo0NwpaX2LzmLTPEDQIS3yYfYgEplxCQ
	ldh0AOxmCYH/bBKfn25ghvhMUuLgihssExjFZiG5aRaSsbOQjF3AyLyKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIyQmpHYwrmywOMQowMGoxMPrVfg1QIg1say4MvcQowQHs5II79cvQCHe
	lMTKqtSi/Pii0pzU4kOMPkDXTmSWEk3OB8ZrXkm8obGBsaGhpaGZqaWpAQ5hJXFexlNPAoQE
	0hNLUrNTUwtSi2DGMXFwSjUwsn0zWMf19QHr2mXez9j//pXZOC/l4PrSWQVFX/cc78o/HbtY
	IbP2ums59142Q6FXM5sWlfxReDfRl2HWuQazzavcLgVkJ0/sPV/KtTV0ifQ2AY5LV6b03Z/y
	0KRgb/z1bzZ/X16VCisxPSC1tf5/Zv6VMOu7cXVV7BW+2YzXv832nL/D/+NGMyWW4oxEQy3m
	ouJEADBTFeq2AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd01Ct8CDHqbrSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqGWbUwF30UrNs8ub2Dc
	wd/FyMkhIWAicXrbazYIW0ziwr31QDYXh5DAIkaJozceMUM4XUwS01qfsIBU8QpoSTRM+8IE
	YrMIqEqcXDcJzGYDiu9/cQOom4NDVCBC4lc/B0S5oMSPyffAWkUENCReHr3FAjKTWeA9o8S9
	SxPAEsJAvUu37IfavJhJ4s2D/cwggzgF9CW2308AqWEW0JHY3zqNDcKWl9i85i3zBEaBWUh2
	zEJSNgtJ2QJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwRH3TGoH48oGi0OMAhyMSjy8
	XoVfA4RYE8uKK3MPMUpwMCuJ8H79AhTiTUmsrEotyo8vKs1JLT7E6AMMgYnMUqLJ+cBkkFcS
	b2hsYmZkaWRmbGJubIxDWEmcl/HUkwAhgfTEktTs1NSC1CKYcUwcnFINjL0cu5cfSN+WdmFp
	9NpvPvmezYynBe2bLsmJ9x6I7Az17TpaxywswXs3cmoA760dTG9qj/XOUtzyRNTTO6Q/N6iM
	t+ya4/tqr5WlJn94Q1YmRfkwhE7R/f824KVuSAnTGZ+JjRtshR9eV99ec3lbXaNaoPXkCNdt
	G696cuxavtjKbQNH9qVTSizFGYmGWsxFxYkAnNpQ8uUCAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 10:49 PM, Greg KH wrote:
> On Tue, Jan 15, 2013 at 10:23:44PM +0900, Chanwoo Choi wrote:
>> On Tuesday, January 15, 2013, Greg KH wrote:
>>
>>     On Tue, Jan 15, 2013 at 09:09:20PM +0900, Chanwoo Choi wrote:
>>     > On Tuesday, January 15, 2013, Greg KH wrote:
>>     >
>>     >     On Tue, Jan 15, 2013 at 04:34:18PM +0900, Chanwoo Choi wrote:
>>     >     > Hi Greg,
>>     >     >
>>     >     > This is the extcon pull request for Linux 3.8-rc4.
>>     >     >
>>     >     > Please pull extcon with following updates:
>>     >     >
>>     >     > Update to max77693/max8997 extcon driver:
>>     >     > - Using MHL_TA cable for charging.
>>     >     > - Support JIG cable.
>>     >     > - Support Dock-Audio device for playing music and button of device.
>>     >     > - Support Dock-Smart device for desktop mode with mouse/keyboard.
>>     >     > - Set default UART/USB path on probe().
>>     >     > - Check the state/type of cable after completing initialization.
>>     >     > - Code clean to remove duplicate code and bug fix related to
>>     sequence of
>>     >     interrupt.
>>     >     > - Fix irq_flag of max8997/max77693 driver.
>>     >     >
>>     >     > Update to arizona extcon driver:
>>     >     > - Headphone measurements.
>>     >     > - Alternative detection mechanism for non-default system designs.
>>     >     > - Microphone clamp integration.
>>     >     > - Support for additional detection pin.
>>     >     > - MICBIAS rise time configuration.
>>     >     >
>>     >     > Thanks in advance for pulling,
>>     >
>>     >     This request is for inclusion in 3.9, right?  This seems much too big
>>     >     for 3.8 at the moment.
>>     >
>>     >  
>>     > If you think that, I agree your opinion about including this request in
>>     3.9.
>>
>>     That's really up to you, as a subsystem maintainer, to decide about.
>>     You need to take bugfixes and ask for them to be included in the 3.8,
>>     and new features and other work, for 3.9.
>>
>>  OK, I will resend pull-request to include only bugfixes patch in 3.8.
>> After released v3.8-rc7 or 3.8-rc8 kernel, I will send pull-request of extcon
>> to include new feature patches of extcon driver in 3.9.
> 
> No, you can send me that pull request now as well, I have two different
> branches, one to go to Linus for this release, and one for the next one.
> Both of them show up in linux-next.  You should have the same.
> 
> So you can send me two pull requests now, does that make more sense?
> 
I understand and thanks for your comment. I will resend only one pull-request for
extcon to include it for -next branch. I don't send separate pull-request
for bugfixes patch.

Best regards and thanks,
Chanwoo Choi

