Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863Ab3BTIGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:06:34 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62185 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934797Ab3BTIGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:06:31 -0500
X-AuditID: cbfee68e-b7fc26d000001938-44-5124840627c9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
 <002d01ce0f31$5940b4b0$0bc21e10$%han@samsung.com>
 <20130220073337.GC2648@core.coreip.homeip.net>
In-reply-to: <20130220073337.GC2648@core.coreip.homeip.net>
Subject: Re: [PATCH 08/11] mfd: ezx-pcap: use devm_request_irq() and
 devm_kzalloc()
Date: Wed, 20 Feb 2013 17:06:30 +0900
Message-id: <000901ce0f41$30a23230$91e69690$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PPJtn/3okzll8SHubFGT4FpuvKAABGmZQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI122FpVAg6dTZS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG2nttTAVzuCo6J/xkamDs5+hi5OSQEDCRmL1+NzOELSZx4d56
	ti5GLg4hgWWMEgvv/GSCKXrQeA0qsYhRYtKi40wQzmwmiSkzprOCVLEJqEl8+XKYvYuRg0NE
	wFBixpoqkDCzQJ7Et0VNbCA2WHPnEUkQm1PAWqK5+ys7iC0sECqx9P8TZpBWFgFVicePKkBM
	XgFbiXkP8kAqeAUEJX5MvscCMVFLYv3O40wQtrzE5jVvwTolBNQlHv3VBQmLCBhJzO7tgCoX
	kdj34h0jyMESAovYJa6f6AFLsAgISHybfIgFoldWYtMBaDBIShxccYNlAqPELCSbZyHZPAvJ
	5llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERJVfTsYbx6wPsSYDLR+IrOUaHI+
	MCrzSuINjY1NzExMTcwtTc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFx
	9WqHyM2cYXHF/RPnNKucc9lxbu40q18csj2pug5rxKcbc8bMYtmlcSWoOPBb76/ScwZcmd4C
	aoybhJj+WKRPmdHw0WW/xI21j+I/3kuYvflISSXbpxf/la/PX1DMKbF8oZWBxY8ttaZyv9bx
	X75XV/VG1bhVs7GOw3PlVPOrgtFR0fMMhNYpsRRnJBpqMRcVJwIAmYL6wcACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgC5bi0qgwaq5EhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+29NqaCOVwVnRN+MjUw
	9nN0MXJySAiYSDxovMYGYYtJXLi3Hsjm4hASWMQoMWnRcSYIZzaTxJQZ01lBqtgE1CS+fDnM
	3sXIwSEiYCgxY00VSJhZIE/i26ImsEFgzZ1HJEFsTgFriebur+wgtrBAqMTS/0+YQVpZBFQl
	Hj+qADF5BWwl5j3IA6ngFRCU+DH5HgvERC2J9TtBLgCx5SU2r3kL1ikhoC7x6K8uSFhEwEhi
	dm8HVLmIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4Jh9JrWDcWWDxSFGAQ5GJR5ejfnKgUKsiWXFlbmHGCU4mJVEeJudVAKFeFMSK6tSi/Lj
	i0pzUosPMSYDvTmRWUo0OR+YTvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1
	ILUIZgsTB6dUA6PKXeVL3pMbXTlUpwdmXw5YzXfopYT7NoXIpm3q33/+3X13x+yDnqxb5sjt
	3Gi+1CT/5/e8Cf85dlc78lzlsJcR/1Ny/f0PGys1z7tmQtOdynt06rZ3fF6x8/5moaddF2WD
	t0UWlXqIJMhMfbbpQ0PA9+hXKRmvbr7x+nXfxz/P55OA343ib++UWIozEg21mIuKEwF9hKTu
	HQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 20, 2013 4:34 PM, Dmitry Torokhov wrote:
> 
> On Wed, Feb 20, 2013 at 03:13:06PM +0900, Jingoo Han wrote:
> > Use devm_request_irq() and devm_kzalloc() to make cleanup paths
> > more simple.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/mfd/ezx-pcap.c |   16 +++++-----------
> >  1 files changed, 5 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
> > index b7a61f0..8dea3a9 100644
> > --- a/drivers/mfd/ezx-pcap.c
> > +++ b/drivers/mfd/ezx-pcap.c
> > @@ -403,7 +403,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
> >  	/* cleanup ADC */
> >  	adc_irq = pcap_to_irq(pcap, (pdata->config & PCAP_SECOND_PORT) ?
> >  				PCAP_IRQ_ADCDONE2 : PCAP_IRQ_ADCDONE);
> > -	free_irq(adc_irq, pcap);
> >  	mutex_lock(&pcap->adc_mutex);
> >  	for (i = 0; i < PCAP_ADC_MAXQ; i++)
> >  		kfree(pcap->adc_queue[i]);
> > @@ -415,8 +414,6 @@ static int ezx_pcap_remove(struct spi_device *spi)
> >
> >  	destroy_workqueue(pcap->workqueue);
> >
> > -	kfree(pcap);
> > -
> 
> I am pretty sure this conversion is wrong as well. Pretty much
> work/workqueue and devm_request_irq() do not mix.

Yes, you're right. 
I will use devm_free_irq().

> 
> Thanks.
> 
> --
> Dmitry

