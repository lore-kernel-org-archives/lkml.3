Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaHNAk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 20:40:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23382 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaHNAkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 20:40:53 -0400
X-AuditID: cbfee690-b7f526d000003627-f1-53ec05902f20
Date: Thu, 14 Aug 2014 09:40:47 +0900
From: Inha Song <ideal.song@samsung.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, lgirdwood@gmail.com, sameo@linux.intel.com,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, cw00.choi@samsung.com
Subject: Re: [alsa-devel] [PATCH v2 2/2] mfd: arizona: Update DT binding to
 support INn_MODE init_data
Message-id: <20140814094047.444a3459@songinha-Samsung-DeskTop-System>
In-reply-to: <20140813121814.GI15833@opensource.wolfsonmicro.com>
References: <20140813205456.636abc68@songinha-Samsung-DeskTop-System>
 <20140813121814.GI15833@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42JZI2JSpDuB9U2wwZ+P3BZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGWsmdHDUvCBr2JH8zrWBsZb3F2M
	nBwSAiYSB45cYYewxSQu3FvP1sXIxSEksJRRovXTcyaYolnLN4HZQgLTGSV2bgyFKOpnkuj5
	eIy1i5GDg0VAVWLz5DCQGjYBDYnvnzczg9giAhYSU5bcArOZBV4wSay5pQViCwtkSJx+eg8s
	zivgKrF82W4mkDGcAo4S05rqIVbVSNw4ew3qNhuJ1TvXQZULSvyYfI8FYqSWxOZtTawQtrzE
	5jVvmUFOkxBYyyFxe85KsASLgIDEt8mHWEDmSwjISmw6wAwxU1Li4IobLBMYxWYhGTsLydhZ
	SMYuYGRexSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREY+6f/PZuwg/HeAetDjMlAKycyS4km
	5wNTR15JvKGxmZGFqYmpsZG5pRlpwkrivGqPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MK57dvvo503/Ph5cfpvvsHVY2Xc5tr5duzNnb5sve+oVy8aObw2Nzw6+n//kdMUXMb45nDuL
	EpI7efdL/12sczh6xrnKuZ/i3fZOlaxhK9tgEFony1CyMlXFJk60S9brtPUe+S1zjiZ7vD9W
	fnFjwQGRpY3fCr7veFHIHbextWBZxb91e2XOaTIosRRnJBpqMRcVJwIATMqaWRMDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd0JrG+CDV52sFhcuXiIyWLqwyds
	Fv+m3GC3uP7lOavF/CPnWC363yxktTj3aiWjxf2vRxktvl3pYLK4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHz
	mHcy0OPlxN9sHn1bVjF6fN4kF8Ad1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQP0i5JCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQ
	sIYxY82MHpaCD3wVO5rXsTYw3uLuYuTkkBAwkZi1fBMThC0mceHeejYQW0hgOqPEzo2hXYxc
	QHY/k0TPx2OsXYwcHCwCqhKbJ4eB1LAJaEh8/7yZGcQWEbCQmLLkFpjNLPCCSWLNLS0QW1gg
	Q+L003tgcV4BV4nly3YzgYzhFHCUmNZUD7GqRuLG2WvsECfYSKzeuQ6qXFDix+R7LBAjtSQ2
	b2tihbDlJTavecs8gVFgFpKyWUjKZiEpW8DIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMj
	OLE8k9rBuLLB4hCjAAejEg+vR9TrYCHWxLLiytxDjBIczEoivMrMb4KFeFMSK6tSi/Lji0pz
	UosPMZoCw2Iis5Rocj4w6eWVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgtgulj
	4uCUamCUSJ5UKC/XxeGY3/rwWdlpP9YdVd8q4tpysxmjeDitrsRvLVx6Ii2n7//NXqbvQXPY
	n5ULvPuu/fnqt9CPVy9vWXe488nFOX53OnpluC7+LPjFalWuM+uJkuoV/vjgm9/3C7Dt2fjf
	6PHaK0EMqv+P3eObM5nNK2aj6+fNVwr/2trefRTHvvihEktxRqKhFnNRcSIAs7X32EIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Charles.
Thanks for your review.

On Wed, 13 Aug 2014 13:18:14 +0100
Charles Keepax <ckeepax@opensource.wolfsonmicro.com> wrote:

> On Wed, Aug 13, 2014 at 08:54:56PM +0900, Inha Song wrote:
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
> > index 5c7e723..b8c131e 100644
> > --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> > +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> > @@ -42,6 +42,14 @@ Optional properties:
> >      the chip default will be used.  If present exactly five values must
> >      be specified.
> >  
> > +  - wlf,inmode : A list of INn_MODE register values, where n is the number
> > +    of input signal. Each input signal path can be configurated either as a
> > +    Analogue or Digital using the INn_MODE registers. If absent, INn_MODE
> > +    registers set to 0 by default. If present, values must be specified less
> > +    than or equal to the number of input singal. If values less than the
> 
> Typo here should be "input signals".

Oops, Thanks! I will fix this.

Best regards,
Inha Song.

> 
> > +    number of input signal, elements that has not been specifed are set to 0
> > +    by default.
> > +
> >    - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
> >      they are being externally supplied. As covered in
> >      Documentation/devicetree/bindings/regulator/regulator.txt
> > -- 
> > 2.0.0.390.gcb682f8
> > 
> 
> Thanks,
> Charles
