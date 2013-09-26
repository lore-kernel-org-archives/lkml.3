Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3IZG0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:26:03 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26091 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3IZG0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:26:01 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-a9-5243d377b263
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'Mark Brown'" <broonie@kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Steve Twiss'" <stwiss.opensource@diasemi.com>,
        "'David Dajun Chen'" <david.chen@diasemi.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
 <000b01ceba5c$e35a8140$aa0f83c0$%han@samsung.com>
 <CAK9yfHxSFZv-=cdsoLzYBBZhShX9iMgoBBfOCJDLA3_P_dGetg@mail.gmail.com>
In-reply-to: <CAK9yfHxSFZv-=cdsoLzYBBZhShX9iMgoBBfOCJDLA3_P_dGetg@mail.gmail.com>
Subject: Re: [PATCH V2 05/18] regulator: fixed: use devm_regulator_register()
Date: Thu, 26 Sep 2013 15:25:59 +0900
Message-id: <002b01ceba81$4413aa10$cc3afe30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66f523Bxm1SeK4RsGE/th9jEnaiwAAVAbw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zQ93yy85BBsfXWFlMffiEzeL2j9Os
	FpcXXmK1+Halg8ni8q45bBYn//QyWlz9vZ7Fgd1jxSd9j52z7rJ7bFrVyeZx59oeNo++LasY
	PT5vkgtgi+KySUnNySxLLdK3S+DK6O58zFYwga1i2o3V7A2MT1m6GDk5JARMJD4t+8AGYYtJ
	XLi3Hsjm4hASWMYosaLhAlzRrZeHmSAS0xklOjY3s0I4vxgl2psuMoJUsQmoSXz5cpgdxBYR
	0JFYsWstWAezwE9GiR3zZrJAdOxglNjaAzKLg4NTIFhi6wFhkAZhAV+J0zMug93BIqAq8W/e
	TmaQEl4BW4ndO3VAwrwCghI/Jt8Du4hZQEti/c7jTBC2vMTmNW/ByiUE1CUe/dWFOMFIYsOb
	z6wQJSIS+168YwS5QELgK7vEwiOL2SFWCUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2z
	kGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIieOJOxjvH7A+xJgMtH4i
	s5Rocj4wDeSVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJ
	g1OqgdHiOoNT1rRzWxLTf2Ul1ak+UNrYurjR0DH5b/30oLSJ9YXT13jKRXzoqkj8eezsEyde
	5eWvUqRSbXZdrW3QFZc7f4F/wpJrf6Kku4IYOF2iGeO+8ftqsfQJ7E+fcScmT9Lk2SKZhMXx
	83giuN58F1rxa+nLJ5cvH/j7IuDNHDX3rAK/ksY1ukosxRmJhlrMRcWJAL9GNQr5AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jQd3yy85BBn1bzCymPnzCZnH7x2lW
	i8sLL7FafLvSwWRxedccNouTf3oZLa7+Xs/iwO6x4pO+x85Zd9k9Nq3qZPO4c20Pm0ffllWM
	Hp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYA3aKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOjufMxWMIGtYtqN
	1ewNjE9Zuhg5OSQETCRuvTzMBGGLSVy4t56ti5GLQ0hgOqNEx+ZmVgjnF6NEe9NFRpAqNgE1
	iS9fDrOD2CICOhIrdq1lAiliFvjJKLFj3kwWiI4djBJbe0DmcnBwCgRLbD0gDNIgLOArcXrG
	ZTYQm0VAVeLfvJ3MICW8ArYSu3fqgIR5BQQlfky+B3Yds4CWxPqdx5kgbHmJzWvegpVLCKhL
	PPqrC3GCkcSGN59ZIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukV
	J+YWl+al6yXn525iBCeJZ9I7GFc1WBxiFOBgVOLhvcDsHCTEmlhWXJl7iFGCg1lJhPebEVCI
	NyWxsiq1KD++qDQntfgQYzLQnxOZpUST84EJLK8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGNOX/Q64ZbRl8vRXRV2pHYlqLGyzuMqm3auZ7v+UO+l08cs3
	XkltWl+SbytH7ux1eLhL96PtXmebDc0yfOe+X+JXN5KzS77i3L14fmmo9ksz8d9/+5Y0/nxk
	vveMPVOS0QoF2RUOWZ6hvWds1zp0reJ6wKvYE2yzR7doQlWl2NVaa4OYhsM7lFiKMxINtZiL
	ihMBKtVATlYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 3:14 PM, Sachin Kamat wrote:
> On 26 September 2013 07:35, Jingoo Han <jg1.han@samsung.com> wrote:
> > Use devm_regulator_register() to make cleanup paths simpler.
> 
> >         struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
> >
> > -       regulator_unregister(drvdata->dev);
> >         kfree(drvdata->desc.supply_name);
> >         kfree(drvdata->desc.name);
> 
> Sorry, couldn't go through all your patches yesterday.
> This one looks a bit scary too as some of the driver data is already
> freed before unregistering.
> 

I looked at regulator_unregister(). I am not sure that this is safe.
So, I will remove this patch from next v3 patch series.
Thank you for your comment. :-)

Best regards,
Jingoo Han

