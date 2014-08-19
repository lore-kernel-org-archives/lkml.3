Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaHSBqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 21:46:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64211 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaHSBqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 21:46:13 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-b1-53f2ac632d2e
Date: Tue, 19 Aug 2014 10:46:11 +0900
From: Inha Song <ideal.song@samsung.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v3 2/2] mfd: arizona: Update DT binding to
 support INn_MODE init_data
Message-id: <20140819104611.121c283b@songinha-Samsung-DeskTop-System>
In-reply-to: <20140818142945.GD7556@opensource.wolfsonmicro.com>
References: <20140818200009.12a52dfa@songinha-Samsung-DeskTop-System>
 <20140818142945.GD7556@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42JZI2JSopu85lOwwbEnkhZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGWsW/iWtWCPYMWqb/3MDYwvebsY
	OTkkBEwkdjTMYoawxSQu3FvPBmILCSxllNi8rximZtPtg0A1XEDxRYwS856/ZoRw+pkk7jQ1
	g3WwCKhKtDz/zwJiswloSHz/vBlsqoiAhcSUJbfAbGaBF0wSa25pgdjCAhkSE+42s4PYvAKu
	Eid3HmUCsTkFHCRu/H7KDnFFtcTOFTcZIa6wkVi9cx0zRL2gxI/J91ggZmpJbN7WxAphy0ts
	XvMW7FIJgS0cEj/O32WEOE5A4tvkQ0ANHEAJWYlNB6A+lpQ4uOIGywRGsVlIxs5CMnYWkrEL
	GJlXMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgTG/+l/z3p3MN4+YH2IMRlo5URmKdHkfGD6
	yCuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRvPV
	3C7TGc7e2eD5aMeG+Y1CWZHXmGX3GW++l3c27hVz5/uOjMD6pVejbfYleTrO3uRe1CzfnTb7
	1HrTkl19dws+6UiXq7xY/eUAI8erusnTzmur11hz999+OZfrhXDldfO5oVJ7pqcquRg7FtZw
	HNt16kypxbaX86deDLYosHe7L/rx6VLPCCWW4oxEQy3mouJEAMms5zIVAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAd3kNZ+CDb6eE7S4cvEQk8XUh0/Y
	LP5NucFucf3Lc1aL+UfOsVr0v1nIanHu1UpGi/tfjzJafLvSwWRxedccNoul1y8yWSx/+5/N
	YsL0tSwWrXuPsFuc7mZ14PfY8LmJzWPNvDWMHpf7epk8ds66y+6xcvkXNo9NqzrZPO5c28Pm
	Me9koMfLib/ZPPq2rGL0+LxJLoA7qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DS
	wlxJIS8xN9VWycUnQNctMwfoFyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmgg
	YQ1jxrqFb1kL9ghWrPrWz9zA+JK3i5GTQ0LARGLT7YPMELaYxIV769m6GLk4hAQWMUrMe/6a
	EcLpZ5K409TMBlLFIqAq0fL8PwuIzSagIfH982awbhEBC4kpS26B2cwCL5gk1tzSArGFBTIk
	JtxtZgexeQVcJU7uPMoEYnMKOEjc+P0ULC4kUC2xc8VNRogrbCRW71zHDFEvKPFj8j0WiJla
	Epu3NbFC2PISm9e8ZZ7AKDALSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7
	iRGcXp5J72Bc1WBxiFGAg1GJh1fhy8dgIdbEsuLK3EOMEhzMSiK8rZM/BQvxpiRWVqUW5ccX
	leakFh9iNAWGxkRmKdHkfGDqyyuJNzQ2MTOyNDI3tDAyNlcS5z3Yah0oJJCeWJKanZpakFoE
	08fEwSnVwDh73Z6i9kX756pG/Pwc7ZzwRPJvcLVwb4jNMx3R56H7G52fnfVJFp0698SufaFt
	RpYnus94L5w17Q537mo27r3r2BfdrrB7nrj1R4Ljoo92wgyrj200e5qqZlrIupxB+VivEEO1
	Ynu2WYLjqVkehx9LSxWrJzwOD7bdLnBjr9+dWUo/YvOfX1RiKc5INNRiLipOBABzE8dzRQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Charles.
Thanks for your review.

On Mon, 18 Aug 2014 15:29:45 +0100
Charles Keepax <ckeepax@opensource.wolfsonmicro.com> wrote:

> On Mon, Aug 18, 2014 at 08:00:09PM +0900, Inha Song wrote:
> > This patch update DT binding to support INn_MODE init_data. Each
> > input signal path can be configurated either as a Analogue or
> > Digital using the INn_MODE registers.
> > 
> > Signed-off-by: Inha Song <ideal.song@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/mfd/arizona.txt | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> > index 5c7e723..0064b21 100644
> > --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> > +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> > @@ -42,6 +42,14 @@ Optional properties:
> >      the chip default will be used.  If present exactly five values must
> >      be specified.
> >  
> > +  - wlf,inmode : A list of INn_MODE register values, where n is the number
> > +    of input signals. Each input signal path can be configurated either as a
> > +    Analogue or Digital using the INn_MODE registers. If absent, INn_MODE
> 
> I would replace the second sentence here with something like
> "Valid values are 0 (Differential), 1 (Single-ended) and 2 (Digital
> Microphone)."
> 

OK, I will fix it like this:

- wlf,inmode : A list of INn_MODE register values, where n is the number
  of input signals. Valid values are 0 (Differential), 1 (Single-ended) and
  2 (Digital Microphone). If absent, INn_MODE registers.........

Best regards,
Inha Song.

> Thanks,
> Charles
> 
> > +    registers set to 0 by default. If present, values must be specified less
> > +    than or equal to the number of input singals. If values less than the
> > +    number of input signals, elements that has not been specifed are set to 0
> > +    by default.
> > +
> >    - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
> >      they are being externally supplied. As covered in
> >      Documentation/devicetree/bindings/regulator/regulator.txt
> > -- 
> > 2.0.0.390.gcb682f8
> > 
