Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaA2H0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 02:26:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:30011 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaA2H0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:26:49 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-c1-52e8ad360374
From: Jingoo Han <jg1.han@samsung.com>
To: "'Jenny Tc'" <jenny.tc@intel.com>, "'Pavel Machek'" <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org,
        "'Dmitry Eremin-Solenikov'" <dbaryshkov@gmail.com>,
        "'Anton Vorontsov'" <cbouatmailru@gmail.com>,
        "'Anton Vorontsov'" <anton.vorontsov@linaro.org>,
        "'Kim Milo'" <Milo.Kim@ti.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Rupesh Kumar'" <rupesh.kumar@stericsson.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Pali Roh?r'" <pali.rohar@gmail.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rhyland Klein'" <rklein@nvidia.com>,
        "'David Woodhouse'" <dwmw2@infradead.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Sebastian Reichel'" <sre@ring0.de>, aaro.koskinen@iki.fi,
        freemangordon@abv.bg, linux-omap@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1390411194-21410-1-git-send-email-jenny.tc@intel.com>
 <1390411194-21410-5-git-send-email-jenny.tc@intel.com>
 <20140128141445.GC8713@xo-6d-61-c0.localdomain>
 <20140129132334.GB15355@jenny-desktop>
In-reply-to: <20140129132334.GB15355@jenny-desktop>
Subject: Re: [PATCH 4/4] power_supply: bq24261 charger driver
Date: Wed, 29 Jan 2014 16:26:45 +0900
Message-id: <000001cf1cc3$7747ac20$65d70460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8cs1NXHko8P06gQ52n7tmqjCqiMgADvo0w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSaUhUURiGOXPv3FnQuI7b0YjC0MzS3D1imkXUpWhBiMIf6jhel3IZZjSi
	H2WZCOY2jqGOgfuSK43ilqaOiLiQ5ohabmSLGi4kjntTjtdg/vbv5T3Px/t+h4+LCebYltyI
	6FhaEi2MtCL4+ID2h4u9e82Cn2NWtQ2qXvBFHxMncaTN6ydQ7pCag8bX59ko89sqhmRv5Bj6
	qnFANZoUDlIXjrBRiTyfjWY1PQCpW18TKK8kHUeTakNUvlOLI9nALgtN9/cQqKy3io1W8z8D
	1LeXClD52j3UMXrN15zqGfrJpl4kpBDUhiYTp1oU0xyqW1OIU/UVdlRx2yKLmhprI6iSJRWb
	Sk1YIahF2S5Btau2OFRaQyWgNkurOVTvRBOLqqja5Nw28uefD6EjIx7SknM+QfzwlP5tlvjZ
	kUf1RQbxoI+fDLhcSLpC7WRIMuDtSzM4PFNHJAM+V0CWAZiU04r/Y97VnNAxAjIbwOx4W4bZ
	AbBLW0voHgjSBq6vd3N02oS8BEt/zQIdhJGNBBxOHAfMxBiALQUtBxSPdIFFjbKDaWPSGxYP
	dBz4OGkNx9MaWTptuO8Ppm8TjDaCW/IZXKcx0g7WtfSyGH0c1lcvY0zTU3Dutz1Twhn29ace
	Iibw/cLKQQdIVvFg89svLCaLhBty1eGWx6CyE2N+wgJ2VUzgGQAq9JIVeskKvWSFXkQBwCuB
	KS0WiaXBYRI3B6kwShoXHeYgiolSAua+ZM1gttNLBUT78TLM0lQUs39/0bGBTi7uzsjN1c3F
	2cPT/f9sK3PDsLlgPwEZJoylH9C0mJYESuIiaakKsLg8y3hwayhpSHRnVHzxyoZ2aSGE7zq4
	E+Bxd+rsntfRYaP7Hq/M0nt3E7af2PSs5+eIy5UBpnKhgdWFidD559+zbrRF5Po75oXylca8
	q2vLISMGDX/Ss4I+VCyNP/bZRWcyVB2fRnyHrZuk/tcvOy3bn7zZbnh6Ncb7qefe5Eu1xcCm
	bUquFS4NFzrZYRKp8C/8zxjydQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAJsWRmVeSWpSXmKPExsVy+t9jQV2ztS+CDKYcl7dY88LB4mLrbRaL
	f7NPsVnMPH+Z3eL6l+esFpOevGe2mLhyMrPF4696Fmu/9rBbXF54idViyeT5rBb3vx5ltLi8
	aw6bxewl/SwWty/zWiz/tY7FYuLp30wWd08dZbNYdnw1q8X7+bcYLU7+6WW0WP4pwmL/FS8H
	cY+j51+xerQ097B5fPs6icVj56y77B6Hvy5k8di8Qstj8Z6XTB53ru1h81jy5hCrR2/zOzaP
	lxN/s3nsPfSD3aNvyypGj+9L17B7HL+xncljxerv7AGCUQ2MNhmpiSmpRQqpecn5KZl56bZK
	3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTnAkFBSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYxZvSc+slU0MhXsXkRTwPjSa4uRg4OCQETid1rFboYOYFMMYkL99az
	gdhCAtMZJaY3aHQxcgHZvxglDv5bB5ZgE1CT+PLlMDuILSLgJLH0431GkCJmgW1sEhdarzNC
	dFxjlNi5YCdYFaeAscSibRPBuoUFbCUWn94PFmcRUJW43reNCcTmBYqf6f/JBmELSvyYfI8F
	xGYW0JJYv/M4E4QtL7F5zVtmiKvVJR791YU4wkji5KleqBIRiX0v3jFOYBSahWTSLCSTZiGZ
	NAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwenxmdQOxpUNFocYBTgYlXh4V1x8
	HiTEmlhWXJl7iFGCg1lJhFdg7osgId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4Hpu68knhD
	YxMzI0sjMwsjE3Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamBkuyaxvNm6uffbs96w
	/d0bWN1fedRMSjS/emGnctazmnVlJYqx66PzZhTUCvbz6TWdvr01LnqBw5mFQb7MMo7VjDvv
	bGh5V3x+cv42mYST6UourQdN9nAIi4g1Gy5/ub736YqDJvp7VnolSoT22q4Ov22nETpJaO5E
	R5GPf2KZptfNPeCz31WJpTgj0VCLuag4EQAurk7c0wMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 29, 2014 10:24 PM, Jenny Tc wrote:
> On Tue, Jan 28, 2014 at 07:14:45AM -0700, Pavel Machek wrote:
> > > +#define BQ24261_ICHRG_MASK		(0x1F << 3)
> > > +#define BQ24261_ICHRG_100ma		(0x01 << 3)
> > > +#define BQ24261_ICHRG_200ma		(0x01 << 4)
> > > +#define BQ24261_ICHRG_400ma		(0x01 << 5)
> > > +#define BQ24261_ICHRG_800ma		(0x01 << 6)
> > > +#define BQ24261_ICHRG_1600ma		(0x01 << 7)
> >
> > First, its mA, not ma.
> 
> Camel Case allowed? Ignore Checkpatch.pl warning?

Yep, Camel Case is allowed by the commit d8b0771 "checkpatch:
extend CamelCase types and ignore existing CamelCase uses in
a patch".

Thus, the following cases are currently allowed.

#define BQ24261_ICHRG_1600ma           (0x01 << 7)
#define BQ24261_ICHRG_1600MA           (0x01 << 7)
#define BQ24261_ICHRG_1600mA           (0x01 << 7)
....

Best regards,
Jingoo Han

> > > +u16 bq24261_iterm[][2] = {
> > > +	{0, 0x00}
> > > +	,
> > > +	{50, BQ24261_ITERM_50ma}
> > > +	,
> > > +	{100, BQ24261_ITERM_100ma}
> > > +	,
> > > +	{150, BQ24261_ITERM_100ma | BQ24261_ITERM_50ma}
> >
> > ...this is very obscure way to do with table what can be done with
> >
> > (x/50) << 3, right ?
> 
> Few register settings need table mapping, but some can have logic as your
> comment say. Just wanted to keep same logic for all register settings.
> Doesn't it make more readable?
> 
> > > +u16 bq24261_cc[][2] = {
> > > +
> > > +	{500, 0x00}
> > > +	,
> > > +	{600, BQ24261_ICHRG_100ma}
> > > +	,
> > > +	{700, BQ24261_ICHRG_200ma}
> > > +	,
> > > +	{800, BQ24261_ICHRG_100ma | BQ24261_ICHRG_200ma}
> > > +	,
> > > +	{900, BQ24261_ICHRG_400ma}
> >
> > I suspect you can get rid of this, too, if you expand macros.
> Same as above comment.
> 
> -Jenny

