Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab3EGHIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:08:13 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:44630 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757959Ab3EGHIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:08:10 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 03:08:10 EDT
Message-ID: <1367910123.12136.7.camel@thor.local>
Subject: Re: [PATCH] radeon: Allow disabling UVD
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Date: Tue, 07 May 2013 09:02:03 +0200
In-Reply-To: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com>
References: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAIAAADYYG7QAAAAA3NCSVQICAjb4U/gAAAQ4UlEQVRYw0VYWY9l51Vda+/vDHequjV1V5fbdsdud+wMNiQIEieAYggJQrwliChP/IBESCABApQXXiJ44AmFIZEQYcggBGRQgjMY2xkd20k7HuKxbcfd7u6qHurWveeec75vbx6+28l9qLp16+ieffa39tprLX73ew8KBXDSAVKcWH0AgHSSbolUuKuKm4vQ3QQ0wN2a+XJ+NE9uRVnUdTUYDEIRVMQ8CSUlFwUlOJwE+PMvFwnmPSW4g4SBhAeSABwgKJKvzbUALgLx5MIAJ8XgrqQ7xNH3/aWLl5954kevvPBCc3QkdADVoJ5u75w8fcddb3rzeG3swUUpJNwgN54QQgIQwoWBIBTJXATu4PcfedgJAQknkevLP8QBirsRoIi7CSkA3Pcv75/9waMvP/3D5tq12WIe+1grh1VdlMFFomPt+M1vvffdb777LWVdCggCAoqamWh+XiEEBEgKUzKnBEFwp9Dh5KpXLkIzqNLhQgcUcAGc7hDz9NTZZx7/1gMTn+2UaaZelVKURRmqqtRQlp07VEo7evbb35hdu/qOX393XVUE4TRzQX5qBeCrgyGdqmIGQAIAuELgjnxQgIDuvjptIQA3cxVNbg898K1nvvPAHbtTdOzatD4opoOiVK/KqirCaG2tKAoIowYtBq+/9sKDX0v3/dZ9RV1mlFJUAIcLxQAyAA6SLiIOUoQkSXchVxB2CEE6kHjjOUTEzO7/yjeefOjrp09MfDlLbaveB/ggYKA6VJaqhdtQdTocbw5H00F1961746uvPvx/30YyIUXy10Io7hAIQaEIFBRSCAoAuBEkHM4MZlLoIAWg5LY6Hnv8iR8/dP/p3fV+dhTnjS1btn3hzuR0c0AJ9QRLlmLhKBIk9Xfffitfe+aJs0/lOijiyDAlmPFOAHSTDPN8i
 DcKz5cpV
	sAWkoA4cP1o8ZXPfvbOvc14dGjLpZvDEgyanO6WzFK02EdLbpF9L9FosUyusfuVN9721IPfnDetO+EQkVwboZ7fkNRVhZLrzFMPSi4PP4MTCYo7vvbV+7fKmJpl6jrvk7VL7yM9OY1mcFif3JLQ3dxSsj6qQQUlvKL+6pmT337gwVVfcoucFBfJhESCuTUilAzgPJue+0XNv+Fw2LLtHnv4wa3JMHVdamOKfXIz693M3eAONxB0gUtMPRziroBCy1AVQW675ZbFT19q+w7IOCIodBFAREGKKKmihYDMaMr9IMUBd88VOkjKk2efRHsId3dz85Rg0dxgluhQUSFDCFrKDTiyKItStSrLIoSgGkRu354899RPCM1sTRdQHPl0BBBVctWtTFueSYoE84f5aneeffTRSVWbJbNkZpZSSp7MALo53OEUwJKZ0V3EUZeDajQejqflcCK5oL29nz7/PJCYh0aYMU0q4KICKEkxc+bVkSszECREqHSniKX0ysvn6ko9JYtmqTXv4UZ3i527OZmsB93czCNJKUqGUFQD1cpNybIsquM7W4eXX0/moIArlhFSKCIETOjIayWzZ54rSl4P7g4ICJqnZj4HxLqUkrnRzd2TuxuDOftlI4bYWWz6fhm7tusttrF3Q9u3Zn2Qoq7LqixGVbloGt5gEiFBdySuGJJCBgedEFlxMwCH5ZWVd5AQImyathfQIhCVZuZQws3MRWgulszFk6WUYqY7F9IjEothUBVLvarEaFy9QNLdQQeVcMBBFRH8fM4dkhG3+ptwuouDh/NFtOTu5m5mMLeU4ACSqGpwkjS49QTFpNSqDIVqIJUCcyy7pcPdMiYUcIeBVAmkk06lCkI+LHcnhRQn3V2EbuYramDqY7/s+hhFacnhdDfANJiaejIpClV4b4qyLqqyqkMRosElpC6xTaFPTdPBPKW0khQiApqbM/csn6OEn00WKHl3qKzaQ5BAij1h0ZMZWA
 gdbdelSL
	rXpU8qVWpMLEMJaFHWRV0b5ErTXbt+cH02h6fdvd0zRQmwj6ltlpmVCQepouaWqQiAQEP+F0TcXTOLi5tBiKxbihBABKWoGcPBvH3h/EHTxmgmkOPrg73p+JbN6fGqLJRSVbO2fe788+cuHrxw6UpKNl5bv3XvxFEf33p6T8xm164DRirFyXzTgiKEOOmwAHehAFCVjDJCiEQRcwc9xv74iROXFwdtTC/tX3n14j7cN0b1KGhK6fJi+dPrzROvHdxxfGNvOlo/6g7n8xcuHMySF2W1vTWZbmyyKr75g8d/cvHy+YOj3UUHz9J0tbvyATqzXNYAwgCVzISA0EGRwKzZkL7+ib87oX7txOn/+tZ3blmrd2p9w86kc57bn80W3bgI4zJR5aFXDw6fe70K5zTUd2xNNoZ6bv/SwjZ39/buuXm6vrXTDQstll/8ny/3DO99z6+IBDhE1AmHK0lRAAGrasA8+S5ZLJklkkfX5xcffmy+UcybdjocnNoebxR45vx+43KFcXO8VoTUDaxKthWxaGVrNFm63jnlYS1b1WRr+5atjZ0fP/n0+9+3c9OZWzfHo2m6vJdaoYCCGwSQ2VVUYRZWVGSmmr0HeMN/iEo7ayx5n+zEZOhmGwNtZ804lJuheNO4VtG2nx/2YkTTx3v3pu+9+64fXpzdfPP46Nr+PadOHNs5dfLmWyf3vBF+tDms9djOD2Yv3Bx7B4Kou2eSkczQ7tQQJA8XBciKLGPNQJr72rHtYjpp0tF6Odoc1l27qArubY/VfTQoDHZ9Xo47jx4Xi+7EbsH5/Hfe/uZnrl+9/bZNeDeuYqX9eDguq+3YxrW6Zruc3nOPqDqcsrrdyljkQXOHavFzYCFLFYqIiBR19YZ3v6vrenc7sTa80sThKKwPdH1SBvFAjCtZr8Nh47tVMQ4F4KdP3nRwMD99y6ntnd2yqFPbVtRRPST1/MX9O+9+G/aOU1aTT8mNCKD6yousTip
 rICeFEKy
	MgZB66z1vC0V1tOyqINPx+JWr/aJ3oUqKjMktvn61uXJtecfWNGhApC3iL9928pGnzy2OOkT3ZRvItomP/vjcg2dffst976EGkCICERFB3goiuQuBK02WF9dKOgoJg6g4bPPUyUlZvd4vTxB7kwqj8vpiefHKoo+W+j6ajUR/8dj6qAoErAhHzeLtd5y5vZm/ePnalXnbmPcv7++eOHbvPW/e3LhUHdtBXucU95Q1qQgMriLuHkiVrKhX2htZ0WZQiXJ999h0bf3FiwtDELSwtFUXLMWTxb7vu9g0XXAS0EokyKKZe4LNmjcd32EV6rre2pwOpkPUoYEmQVhNuGfKdhAOFRrFzYWkrXSIUERE6STgMFF1Z1nXv/7hPxhUdetwA+jwpMIqyGRQF0ShxfraqKpLDVKWhYtX6zvHdo9ffPEJj8u6KENQp6W+r/ZuFQaI4mfLC8x+zKFmiSri8NURZu39M5+vOR4Qh9z5a/fe93sfWiT2EHclWQhGw3I8KqN7VWoISdgLXYqCVR0qmW6uzR2vPvtji42KUEMX4/TkLdQsgtywet3Qm06quwupq5ETcYg7KJohZu4QEVGR8Bvv/+1T97w9EhZEhGUR1kaD2byJzoNF99z5w/3Dtuvb2DV1XXbN9SdeuDDYPnUwm13ZvxAtQtgVo/XphlDhTopAQMlGi5CsCAGIqzL3KacNupJzcMiKwYWUtcnaO+57bx8KA0BWg/ooxoN5bCAxBA5HvdSY7KSquLpsvvvi61cMcbRe7p7aP7zWdR2I4vjNogSNKzVPAAYacn4BZnVk5lDJ8tDzhQpD9q0qGekCkG8488ZivLlMSIAU+srVw0WhUaUIOhrodK0ajEbXW5y/cDASr4f1YDIcH9+dg4nJgDScEgTVfZUjuAgABx1w0ewVJfuerLCD0gkDBSKrMSPd8zIJQTd2tlu3nj6PfQJGtdZBx5VsBWxarK9e3jE/WQ+Hi6ObatsZcVjB
 y7CwuJCQ
	ilpECaoqqJbdq6uAvpJr6mAQFSaHkqBlYeCeFa+56w3la4a//fjHFy8+3QFL9858PCjaeXPhwrWjpq807G5Ox7PD2+utg6vXXnrsLL/av/Odd22d2vVi0GpZ1NullFmX3vDvArc82lmIZJcahGoSSXVCaO5Z2at5gmiyJEE8pm9+4xuf//znf/fuPQcWMc37SIiRO9PhWPoRdNpzfbTWnN/fvWn8C+96H0K/+YbRhfnRZDTRciAbe3mINcdg+TZcOUEnnQ6IkcHMszgzT8zJEGirCAZwofl8Mf+nf/yU0NWjptQmNH1kSgLWI6mrQdHrgPV0bTRd37rpzJmdk1vr28VRatdEytFY1jZlOAadDssbIbeKFEhyV1k5D8ICqEKYW/bzoMPd6Up6SqKFe/yHv//kc889PxHE2BfwWbSqNSWGdA0qoagnw3ptKuvjYmd9OYlhnS1SVQ62yzKMhmmyA5IQZyLFDCri5lTaKum4Mfb55CwHkRA43KAQz5GpiLs9+oNHP/eZz8W+u9YsZ4vWE2CYL1u49waTUBZS1QWFEdqhEC26GKMJNBRFdf1o8Wcf+/hsNltRn6W8KigkAwmKgBChAaToR/7wj7jyFyDFYdRspUH4lf2Dj37ko/uXL8W+7y0FTzujUhR974WIkNCiLosilCFUZV0X9WA8GpdlpWUZqmI0qT/zpa//5/3f+eHZpy+cvzCajLe2t8ifR2fM4ppiWZMRAUKBO1y1cO/pcGfs4z9/6p8e+NrX9g+uXLx0uU/R3Dzh3JXFzZujtcmwQVp2PcsikG1PuonEvk8p+qK1oQcxqSl9133+qw+2XfvkE0++duHg3//jv7e2Nn7p7W/74Ic/cNebzjhcyGROWE6IzBFyikjRZL2QIprMvvTFL3zyHz7VxzYl6/su5x4OO+z9tSvz4aiaDMuj2aISSeqi7rFTXTMD3QpBKZiUoRZ5+Pvfvz5bWLTr1w8m02NdTK++cv7Sp
 Sv3f/2Bu
	+++6/c/9IF3vPtdVV0QSO4KcXiwlFTVk4lmt8p/+/SnP/mPn4opdV2fUkwe3SzHLga8etgca/pj0/Hm1sbi6mxcRorS03BUhOCVaqU2FPPYxSg/eubZSSlXlwmxn82uDieb7bKZzWdVGn7/kbNnzz512+nTH/rwB99z371VXUcqYMHNI+yHj3z3K1/+39GwSo4vffGLTdu1fRdjTDGCbnYjBXK/PLeXLs2H9WBnOtw4td5cOwxFWaggxWIyLMehje2Vo6vbw2Pi6fVLV+uqNGshaXZ4MFjfVq1iarq2CyEk92efe/lv/voTn/vsF/74Tz9y111nSA2f/pd//eb997/08mvNcpH6hcOA4EDOVZO1pDt89YI7+OyluUgYVtX62vro5LA5nIdRbZMq1brUuL6xuXvTyXE5OvuTp4+aJcHkJimmrl8eHRpAwLyPTk3edi0Rn3+x+4s//6u//NifvPWtd+rzz796+eBa1/du0VIf+xhj6ykC4jRHMour9BG+0kvCwyYt2+7EzsZ0czslmnUbmxvbx3Z3Nrd2t4/VRd3G+O3Hzr547qf7h83BoiVA5XA0bRZzZ3AIGcwsizEnLaazTzzznt98l9bVQOgxdU5xS33qzTylZN4TVAkp9Vni3khtoFIk2MFRdzjvN0eD8cba4eHcGSbj8aCszdk2yz76Q9979PLB5deuzWZdDwIS6uG076NZ1KKAKCGgrFhQ1ZJtbW+phCKH9zAC5ta7mbmZJbecS7ibZb9yI8jOKZPPW7x08WqAp4QY0+bGtlKuH82t96Nm+cjjjzfN/MXLh52tAph6OK3qsu/asqwo4sx+i1AJImVVDMbr/w/Q9qYPnQtQagAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.0-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-06 at 19:11 -0400, Parag Warudkar wrote:
> Apparently UVD doesn't yet work everywhere - so allow it to be
> disabled. Shaves off some reboot and suspend/resume time on machines
> where it doesn't work. Might be useful for problematic chips in the
> future as well.
> 
> Patch attached as well as inline below.
> 
> Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

[...]

> @@ -168,6 +169,9 @@ int radeon_fastfb = 0;
>  MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
>  module_param_named(no_wb, radeon_no_wb, int, 0444);
> 
> +MODULE_PARM_DESC(no_uvd, "Disable UVD");
> +module_param_named(no_uvd, radeon_no_uvd, int, 0444);

No more negative boolean options please.


> diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c
> b/drivers/gpu/drm/radeon/radeon_uvd.c
> index 906e5c0..93a7dbb 100644
> --- a/drivers/gpu/drm/radeon/radeon_uvd.c
> +++ b/drivers/gpu/drm/radeon/radeon_uvd.c
> @@ -58,7 +58,8 @@ int radeon_uvd_init(struct radeon_device *rdev)
>   unsigned long bo_size;
>   const char *fw_name;
>   int i, r;
> -
> + if (radeon_no_uvd)
> + return -EINVAL;
>   INIT_DELAYED_WORK(&rdev->uvd.idle_work, radeon_uvd_idle_work_handler);

Returning -EINVAL here results in rather misleading dmesg output I
think. This should probably be handled more gracefully.

Anyway, the return statement would need to be indented per the kernel
coding style, and please leave empty lines before the if and after the
return.


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
