Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbbAPKRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:17:35 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35290 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbAPKRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:17:31 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-24-54b8e538ae31
Message-id: <54B8E534.5080506@samsung.com>
Date: Fri, 16 Jan 2015 11:17:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Brown <broonie@kernel.org>, Rob Herring <robherring2@gmail.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        sakari.ailus@iki.fi, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com>
 <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <20150112170644.GO4160@sirena.org.uk> <54B7B39C.7080204@samsung.com>
 <20150115210310.GB24008@amd>
In-reply-to: <20150115210310.GB24008@amd>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t/xa7oWT3eEGJw9pG6xccZ6VoupD5+w
	WRzdOZHJYv6Rc6wW/W8Wslqce7WS0aL36nNGi7NNb9gtvl3pYLK4vGsOm8XWN+sYLXo2bGW1
	WHr9IpPF3VNH2SwmTF/LYtG69wi7xfdv39gsdu96ympxZv9KNgdhjzXz1jB6XO7rZfLYOesu
	u8fK5V/YPA5/XcjisWlVJ5vHnvk/WD36tqxi9Fix+ju7x+dNcgFcUVw2Kak5mWWpRfp2CVwZ
	+6dJFizmrrjz6AprA+Nyji5GTg4JAROJP5dbWCBsMYkL99azdTFycQgJLGWUmPH+MhOE84lR
	Ytqua2BVvAJaEod//WUDsVkEVCVePN4BZrMJGEr0Hu1jBLFFBSIkTt7dww5RLyjxY/I9sF4R
	AXmJrX0rmEGGMgt8ZZW4MXE6M0hCWMBVYnb7YmaIbU0sEstuHWcCSXAKaEps6tvC2sXIAdSh
	J3H/ohZImBlo0OY1b5knMArMQrJjFkLVLCRVCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefn
	bmKExOOXHYyLj1kdYhTgYFTi4Z2xZUeIEGtiWXFl7iFGCQ5mJRHejduAQrwpiZVVqUX58UWl
	OanFhxiZODilGhhNPK1POOnqPTv6JpC9pMQmdDGDdcL2eUdkDJiFu+zmLi/IevWvamJn5NrN
	5mUbTXfrVAXG+3+VeHdg9Rs1Q5eanAmVdgrcd7lkLn91Np3HdUd92YuoHUoznrnnHvDa+9tO
	JMtogovd0SQ7K8Xdex2VlCce/iXXarr1NHtUU9jVI909LYbu8kosxRmJhlrMRcWJAOVxrWul	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 15/01/15 22:03, Pavel Machek wrote:
>> Perhaps we could use the 'reg' property to describe actual connections,
>> > I'm not sure if it's better than a LED specific property, e.g.
>> > 
>> > max77387@52 {
>> >         compatible = "nxp,max77387";
>> >         #address-cells = <2>;
>> >         #size-cells = <0>;
>> >         reg = <0x52>;
>> > 
>> > 	flash_led {
>> > 		reg = <1 1>;	
>> > 		...
>> > 	};	
>> > };
>
> Normally, reg property is <start length>, if I understand things
> correctly? Would that be enough here, or would we be doing list of
> outputs?

In general the exact meaning depends on value of the #address-cells and
#size-cells properties in the parent node.  In case as above #size-cells
is 0.  You can find exact explanation in [1], at page 25.

Anyway, the above example might an abuse of the simple bus. I thought more
about a list of outputs, but the indexes wouldn't be contiguous, e.g.

 curr. reg. outputs | "addres" value
--------------------------------
FLED2    FLED1      |  reg
--------------------+-----------
  0        1        | 0x00000001
  1        0        | 0x00010000
  1        1        | 0x00010001

But it might be not a good idea as Rob pointed out.

OTOH we could simply assign indices 1,2,3 to the above FLED1/2 output
combinations.

[1] https://www.power.org/wp-content/uploads/2012/06/Power_ePAPR_APPROVED_v1.1.pdf

--
Regards,
Sylwester
