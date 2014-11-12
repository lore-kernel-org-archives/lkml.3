Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaKLRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:09:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51604 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbaKLRJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:09:25 -0500
Message-ID: <54639423.3030607@ti.com>
Date: Wed, 12 Nov 2014 11:08:51 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv6 1/5] Documentation: dt: add common bindings for hwspinlock
References: <1410553499-55951-1-git-send-email-s-anna@ti.com> <1410553499-55951-2-git-send-email-s-anna@ti.com> <CAK=WgbZqj23J4M8n5FOkPdUOcyK3==TXgc3DfX=LKS6E8C+-Bg@mail.gmail.com>
In-Reply-To: <CAK=WgbZqj23J4M8n5FOkPdUOcyK3==TXgc3DfX=LKS6E8C+-Bg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar, Mark, Rob,

On 11/12/2014 09:14 AM, Ohad Ben-Cohen wrote:
> Hi Suman,
> 
> On Fri, Sep 12, 2014 at 11:24 PM, Suman Anna <s-anna@ti.com> wrote:
>> This patch adds the generic common bindings used to represent
>> a hwlock device and use/request locks in a device-tree build.
>>
> ...
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
>> ---
>>  .../devicetree/bindings/hwlock/hwlock.txt          | 55 ++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
> 
> Please ask a DT maintainer to ACK this - otherwise I can't send this to Linus.
> 

Can one of you ack this patch and the next patch [1] so that Ohad can
pick up the series for 3.19? This series has been in works for quite
some time now and was reviewed by each of you at some point of time
(thanks!!), the cover letter [2] has the history of the changes.

regards
Suman

[1] https://patchwork.kernel.org/patch/4898001/
[2] http://marc.info/?l=linux-omap&m=141055365213895&w=2

