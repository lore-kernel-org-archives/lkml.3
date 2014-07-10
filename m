Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaGJC3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 22:29:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61397 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbaGJC3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 22:29:01 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-51-53bdfa6b9c67
From: Jingoo Han <jg1.han@samsung.com>
To: "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: "'Bryan Wu'" <cooloney@gmail.com>,
        "'Jean-Christophe Plagniol-Villard'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Linux Fbdev development list'" <linux-fbdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <1404763270-24932-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140709163050.GM2635@lee--X1>
 <CAFo99gYErPZo_f-5kZkDqZ0YSPirE1fLn2F1odMPSjuUdLUQ8A@mail.gmail.com>
In-reply-to: <CAFo99gYErPZo_f-5kZkDqZ0YSPirE1fLn2F1odMPSjuUdLUQ8A@mail.gmail.com>
Subject: Re: [PATCH] video: backlight: jornada720_lcd.c: Cleaning up variable
 that is never used
Date: Thu, 10 Jul 2014 11:28:58 +0900
Message-id: <003001cf9be6$b45cfcd0$1d16f670$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+bwk1Ou4MeXQTKSQCe3/olWMsAtAAIt7Mg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zQ93sX3uDDW585bc4unMik8XlhZdY
	Le5/PcpocaLvA6vF5V1z2CzWPXzBZHF6501Wi/Xzb7E5cHjsnHWX3ePVhTssHneu7WHz6Nuy
	itGjveEno8fxG9uZPD5vkgtgj+KySUnNySxLLdK3S+DK6Jq2gLXgoHrFi2ub2RsYJ8t0MXJw
	SAiYSEw+6djFyAlkiklcuLeerYuRi0NIYBmjRO+PX8wQCROJU+evskAkpjNK3Fl4kB3C+c0o
	MfflF7AqNgE1iS9fDrOD2CICGRLH2hrAipgFJjJJvLr8gRmi4yCjxMOm+WwgVZwCwRLv121g
	BLGFBZIkPj+bxQpiswioSjxe2ccIch+vgK3Ei9e2IGFeAUGJH5PvsYDYzALqEpPmLWKGsOUl
	Nq95ywzxjrrEo7+6EDcYSSyfMp8RokREYt+Ld4wgJ0gItHJInLzeywaxSkDi2+RDLBC9shKb
	DkB9LClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7u
	JkZIdPfuYLx9wPoQYzLQ+onMUqLJ+cDkkFcSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjAd+WAQ85LuWysGZwK65w+7yfi6v+oRZl66fdGiXWm+l
	yRRl+j9VL2FTvNMHw9nZUrccLgau+F97qchT+/ybv0ql5icystPyCjilyo+bbNzy4Fpq3xOp
	q9EveNfdshGoriyOXl9bNvOSEsep0CxnKX2HM0XHj/8LuLl3a4x+v0L7vjuSK68cU2Ipzkg0
	1GIuKk4EAJN6VMYEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd3sX3uDDV7O4bY4unMik8XlhZdY
	Le5/PcpocaLvA6vF5V1z2CzWPXzBZHF6501Wi/Xzb7E5cHjsnHWX3ePVhTssHneu7WHz6Nuy
	itGjveEno8fxG9uZPD5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBX
	UshLzE21VXLxCdB1y8wBOktJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjH
	mNE1bQFrwUH1ihfXNrM3ME6W6WLk5JAQMJE4df4qC4QtJnHh3nq2LkYuDiGB6YwSdxYeZIdw
	fjNKzH35hRmkik1ATeLLl8PsILaIQIbEsbYGsCJmgYlMEq8uf2CG6DjIKPGwaT4bSBWnQLDE
	+3UbGEFsYYEkic/PZrGC2CwCqhKPV/YBxTk4eAVsJV68tgUJ8woISvyYfA/sJGYBdYlJ8xYx
	Q9jyEpvXvGUGKZcAij/6qwtxg5HE8inzGSFKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlW
	MYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQnj2fSOxhXNVgcYhTgYFTi4W3o2RssxJpYVlyZ
	e4hRgoNZSYT3VglQiDclsbIqtSg/vqg0J7X4EKMp0J8TmaVEk/OBiS2vJN7Q2MTMyNLIzMLI
	xNxcSZz3YKt1oJBAemJJanZqakFqEUwfEwenVAPjgqJjSppz0naWWN+Yn/jnye9dbRxxP4I2
	R3KwTN9873ludSJ7pHiihWj2pLT80t02WQf/vC3LS8lyXGKbytZUzJ+2euKp+W/N5Wzcd3EX
	Rc08tq2ExXHpo42ZBUX8dkKCzCpef7JPPHfOVYk76RfJF+Ign/glsu2oa7RGqlTpk1dz4iz0
	LyqxFGckGmoxFxUnAgCeEyJ/NAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 10, 2014 7:08 AM, Rickard Strandqvist wrote:
> 2014-07-09 18:30 GMT+02:00 Lee Jones <lee.jones@linaro.org>:
> > On Mon, 07 Jul 2014, Rickard Strandqvist wrote:
> >
> >> Variable ar assigned a value that is never used.
> >> I have also removed all the code that thereby serves no purpose,
> >> and made same change to clarify the similarities in function.
> >>
> >> This was found using a static code analysis program called cppcheck
> >>
> >> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> >> ---
> >>  drivers/video/backlight/jornada720_lcd.c |   31 ++++++++++++++----------------
> >>  1 file changed, 14 insertions(+), 17 deletions(-)
> >>
> >> diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
> >> index da3876c..d16abcf 100644
> >> --- a/drivers/video/backlight/jornada720_lcd.c
> >> +++ b/drivers/video/backlight/jornada720_lcd.c
> >> @@ -36,44 +36,41 @@ static int jornada_lcd_get_power(struct lcd_device *ld)
> >>
> >>  static int jornada_lcd_get_contrast(struct lcd_device *ld)
> >>  {
> >> -     int ret;
> >> +     int ret = -ETIMEDOUT;
> >>
> >>       if (jornada_lcd_get_power(ld) != FB_BLANK_UNBLANK)
> >>               return 0;
> >>
> >>       jornada_ssp_start();
> >>
> >> -     if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
> >> +     if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY)
> >>               dev_err(&ld->dev, "get contrast failed\n");
> >> -             jornada_ssp_end();
> >> -             return -ETIMEDOUT;
> >> -     } else {
> >> +     else
> >>               ret = jornada_ssp_byte(TXDUMMY);
> >> -             jornada_ssp_end();
> >> -             return ret;
> >> -     }
> >> +
> >> +     jornada_ssp_end();
> >> +
> >> +     return ret;
> >>  }
> >>
> >>  static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
> >>  {
> >> -     int ret;
> >> +     int ret = -ETIMEDOUT;
> >>
> >>       jornada_ssp_start();
> >>
> >>       /* start by sending our set contrast cmd to mcu */
> >> -     ret = jornada_ssp_byte(SETCONTRAST);
> >> -
> >> +     if (jornada_ssp_byte(SETCONTRAST) != TXDUMMY)
> >> +             dev_err(&ld->dev, "set contrast failed\n");
> >>       /* push the new value */
> >> -     if (jornada_ssp_byte(value) != TXDUMMY) {
> >> +     else if (jornada_ssp_byte(value) != TXDUMMY)
> >>               dev_err(&ld->dev, "set contrast failed\n");
> >> -             jornada_ssp_end();
> >> -             return -ETIMEDOUT;
> >> -     }
> >> +     else /* if we get here we can assume everything went well */
> >> +             ret = 0;
> >>
> >> -     /* if we get here we can assume everything went well */
> >>       jornada_ssp_end();
> >>
> >> -     return 0;
> >> +     return ret;
> >>  }
> >>
> >>  static int jornada_lcd_set_power(struct lcd_device *ld, int power)
> >
> > Counter suggestion.
> >
> > What do you think, I think this looks cleaner:
> >
> > static int jornada_lcd_get_contrast(struct lcd_device *ld)
> > {
> >         int ret;
> >
> >         if (jornada_lcd_get_power(ld) != FB_BLANK_UNBLANK)
> >                 return 0;
> >
> >         jornada_ssp_start();
> >
> >         if (jornada_ssp_byte(GETCONTRAST) == TXDUMMY) {
> >                 ret = jornada_ssp_byte(TXDUMMY);
> >                 goto success;
> >         }
> >
> >         dev_err(&ld->dev, "failed to set contrast\n");
> >         ret = -ETIMEDOUT;
> >
> > success:
> >         jornada_ssp_end();
> >         return ret;
> > }
> >
> > static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
> > {
> >         int ret = 0;
> >
> >         jornada_ssp_start();
> >
> >         /* start by sending our set contrast cmd to mcu */
> >         if (jornada_ssp_byte(SETCONTRAST) == TXDUMMY) {
> >                 /* if successful, push the new value */
> >                 if (jornada_ssp_byte(value) == TXDUMMY)
> >                         goto success;
> >         }
> >
> >         dev_err(&ld->dev, "failed to set contrast\n");
> >         ret = -ETIMEDOUT;
> >
> > success:
> >         jornada_ssp_end();
> >         return ret;
> > }
> 
> 
> Hi Lee!
> 
> Yes, I agree!
> Both are clean without so much repetition of code, which was what annoyd me.
> But yours is clearer when things go good or bad, nice 1 ;)

Hi Rickard Strandqvist,

I would liked to prefer Lee Jones's code. It looks cleaner.

> 
> I do not know what I can/may do, but I'll try. Remove what is not ok :-)
> 
> Reviewed-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> Suggested-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

I suggest the following.

Suggested-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>

Best regards,
Jingoo Han

> 
> 
> Kind regards
> Rickard Strandqvist

