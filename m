Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935089Ab3DPAxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:53:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19135 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934340Ab3DPAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:53:14 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-82-516ca0f89365
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Andrew Bresticker'" <abrestic@chromium.org>
Cc: linux-fbdev@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1365705391-23181-1-git-send-email-abrestic@chromium.org>
 <1365711890-15168-1-git-send-email-abrestic@chromium.org>
 <20130415160632.99e867b25418189c95fbc826@linux-foundation.org>
In-reply-to: <20130415160632.99e867b25418189c95fbc826@linux-foundation.org>
Subject: Re: [PATCH v2] backlight: platform_lcd: introduce probe callback
Date: Tue, 16 Apr 2013 09:53:12 +0900
Message-id: <001601ce3a3c$c5680360$50380a20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac46LeKZhi0rVs/OTPqR9+ndlryezwADcJeQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t8zfd0fC3ICDb79UbRY+f4vo8Wc9WvY
	LM4uO8hm0TnzGqPF5YWXWC1O9H1gtbi8aw6bxe5dT1kdODxmN1xk8fjwMc7jxIzfLB575v9g
	9ejbsorR4/MmuQC2KC6blNSczLLUIn27BK6MO091Cj7yV5z9/pyxgfEyTxcjJ4eEgInE+dvf
	2CBsMYkL99YD2VwcQgLLGCW2ruhngSn6teAGO0RiEaPEls6zzBDOL0aJv1P6mUCq2ATUJL58
	OcwOYosIxEmc7XvFCFLELPCOUeLnjpssEB2HGCVeP7wKlOHg4BTwlvj/XRGkQVjAU2L+28VM
	IGEWAVWJ35u0QMK8ArYS754fZ4GwBSV+TL4HZjMLaEms33mcCcKWl9i85i0zSKuEgLrEo7+6
	ECcYSWxfc5ERokREYt+Ld2DnSAj8ZJfYf+szM0iCRUBA4tvkQywQvbISmw4wQzwsKXFwxQ2W
	CYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5yfu4mRkg8T9zBeP+A
	9SHGZKD1E5mlRJPzgekgryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2M8xbsbjETvFTL/Pn647MXnBR39Qk/1N2nrs7MM0XE5nuCuw/HSSY2KfeO
	A/6/nNaevLzeqX7to75/xSY3Nvyzst7l+HupjnWlc4nAyio5TcG0vDVz07Vc2IXaLcx5VnIf
	/T3R3XNj5XHDBL/T607/a+t+LcWwX/sX09mm2VclA6af4lvGx3hGiaU4I9FQi7moOBEAEAv6
	X/0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAd0fC3ICDS5vkbVY+f4vo8Wc9WvY
	LM4uO8hm0TnzGqPF5YWXWC1O9H1gtbi8aw6bxe5dT1kdODxmN1xk8fjwMc7jxIzfLB575v9g
	9ejbsorR4/MmuQC2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGXee6hR8
	5K84+/05YwPjZZ4uRk4OCQETiV8LbrBD2GISF+6tZ+ti5OIQEljEKLGl8ywzhPOLUeLvlH4m
	kCo2ATWJL18Og3WICMRJnO17xQhSxCzwjlHi546bLBAdhxglXj+8CpTh4OAU8Jb4/10RpEFY
	wFNi/tvFTCBhFgFVid+btEDCvAK2Eu+eH2eBsAUlfky+B2YzC2hJrN95nAnClpfYvOYtM0ir
	hIC6xKO/uhAnGElsX3OREaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnCyeCa1g3Flg8UhRgEORiUe3gD5nEAh1sSy4spcoFc5mJVEeG9l
	AoV4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5jI8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBq
	HSgkkJ5YkpqdmlqQWgSzhYmDU6qB8eyHM6Ff/wqLPY48ZqGSz7hpWiXf7DkVKTEmPesy5PR5
	F2Ve0HjUd43twbHa2oSfz1JbAgqX2bm3X+4IKY27afQmz8BmgUYK6w//Gy5FmbW9+4rOr/ti
	oNh6qqHH7nPZ1EuqnGvO/nr2vcg71yV2w4072rpbTJh9jh2O27NJ2ZhhqdiESc3tSizFGYmG
	WsxFxYkAzPD44FoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 16, 2013 8:07 AM, Andrew Morton wrote:
> 
> On Thu, 11 Apr 2013 13:24:50 -0700 Andrew Bresticker <abrestic@chromium.org> wrote:
> 
> > Platform LCD devices may need to do some device-specific
> > initialization before they can be used (regulator or GPIO setup,
> > for example), but currently the driver does not support any way of
> > doing this.  This patch adds a probe() callback to plat_lcd_data
> > which platform LCD devices can set to indicate that device-specific
> > initialization is needed.
> >
> > index 17a6b83..f46180e 100644
> > --- a/drivers/video/backlight/platform_lcd.c
> > +++ b/drivers/video/backlight/platform_lcd.c
> > @@ -86,6 +86,12 @@ static int platform_lcd_probe(struct platform_device *pdev)
> >  		return -EINVAL;
> >  	}
> >
> > +	if (pdata->probe) {
> > +		err = pdata->probe(pdata);
> > +		if (err)
> > +			return err;
> > +	}
> > +
> >  	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
> >  			    GFP_KERNEL);
> >  	if (!plcd) {
> > diff --git a/include/video/platform_lcd.h b/include/video/platform_lcd.h
> > index ad3bdfe..23864b2 100644
> > --- a/include/video/platform_lcd.h
> > +++ b/include/video/platform_lcd.h
> > @@ -15,6 +15,7 @@ struct plat_lcd_data;
> >  struct fb_info;
> >
> >  struct plat_lcd_data {
> > +	int	(*probe)(struct plat_lcd_data *);
> >  	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
> >  	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
> >  };
> 
> Sigh.  I see that this entire interface has been lovingly undocumented.
> It's an invitation for us to grow bugs, incompatibilities, leaks, etc.
> 
> Possible example: what happens if pdata->probe does some resource
> allocation or device initialisation which should be backed out if, say,
> platform_lcd_probe() later fails?

Hi Andrew,

I agree with you.
Indeed, the documentation is necessary.

Andrew Bresticker,
Would you make the document?
It would be very helpful.

Best regards,
Jingoo Han


