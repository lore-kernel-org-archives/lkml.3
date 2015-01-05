Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbbAEGUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 01:20:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37478 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbAEGUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 01:20:09 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-00-54aa2d17be78
From: Jingoo Han <jg1.han@samsung.com>
To: "'Zhang Rui'" <rui.zhang@intel.com>
Cc: "'Aaron Lu'" <aaron.lu@intel.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1419997818-19528-1-git-send-email-aaron.lu@intel.com>
 <1419997818-19528-2-git-send-email-aaron.lu@intel.com>
 <000b01d026f1$408e3620$c1aaa260$%han@samsung.com> <54AA253F.2030207@intel.com>
 <1420437677.3090.1.camel@rzhang1-toshiba>
In-reply-to: <1420437677.3090.1.camel@rzhang1-toshiba>
Subject: Re: [PATCH 1/3] video / backlight: add two APIs for drivers to use
Date: Mon, 05 Jan 2015 15:20:45 +0900
Message-id: <000301d028af$bd6b5460$3841fd20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AdAorQkMY+u1fK6xSMqlu8it00ew9wAAfvRQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWyRsSkRVdcd1WIwZFOWYtNfb/ZLC4vvMRq
	cf/rUUaL5fv6GS0u75rDZvG59wijxZnTQIknD/vYHDg8Fu95yeRx59oeNo8tV9tZPPq2rGL0
	+LxJLoA1issmJTUnsyy1SN8ugStjd+9C1oLzGhUfZy9ha2DsUOhi5OSQEDCRWDBnJyuELSZx
	4d56ti5GLg4hgaWMEkdatjLDFPVdOMYGYgsJTGeU+HuzFqLoF6PE2dNHwYrYBNQkvnw5zA5i
	iwioStw63cMEUsQs8IFR4vSe7ewQHT8YJR7sOc8EUsUpYCbxfs1HFhBbWMBbYt/k2WArWIC6
	z77tAZvEK2Arcf5VIyOELSjxY/I9sHpmAXWJSfMWMUPY8hKb17wFsjmATlWXePRXF8QUETCS
	WLU3DKJCRGLfi3eMICdICLxll5hybTULxCoBiW+TD7FAtMpKbDoA9bCkxMEVN1gmMErMQrJ4
	FpLFs5AsnoVkxQJGllWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgZF8+t+zCTsY7x2wPsQo
	wMGoxMPrcWJliBBrYllxZe4hRlOgiyYyS4km5wPTRV5JvKGxmZGFqYmpsZG5pZmSOO9rqZ/B
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhh5DV9Hrz6XWFOppp1nKRu8LGD5FpXpjdvvXzxU
	4rm/Mt7feamzq/wH1kdpj9WPmiz1v6kjZbqt5EKCWu2EmRlFwmLse/6Vstsn9miVb5+dsNml
	gvswm27ts6dTntz02CL4f74n742rni92S8mJ/RCaPIHd5fqsT/sdZ55Lqpqo9ZLDzZcl7qUS
	S3FGoqEWc1FxIgBN4NaD3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV1x3VUhBjfeiFts6vvNZnF54SVW
	i/tfjzJaLN/Xz2hxedccNovPvUcYLc6cBko8edjH5sDhsXjPSyaPO9f2sHlsudrO4tG3ZRWj
	x+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+Abpu
	mTlAxygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM3b3LmQtOK9R8XH2
	ErYGxg6FLkZODgkBE4m+C8fYIGwxiQv31oPZQgLTGSX+3qztYuQCsn8xSpw9fZQZJMEmoCbx
	5cthdhBbREBV4tbpHiaQImaBD4wSp/dsZ4fo+MEo8WDPeSaQKk4BM4n3az6ygNjCAt4S+ybP
	BlvBAtR99m0P2CReAVuJ868aGSFsQYkfk++B1TMLqEtMmreIGcKWl9i85i2QzQF0qrrEo7+6
	IKaIgJHEqr1hEBUiEvtevGOcwCg0C8mgWUgGzUIyaBaSlgWMLKsYRVMLkguKk9JzDfWKE3OL
	S/PS9ZLzczcxgtPEM6kdjCsbLA4xCnAwKvHwepxYGSLEmlhWXJl7iFGCg1lJhHfdLaAQb0pi
	ZVVqUX58UWlOavEhRlOgPycyS4km5wNTWF5JvKGxiZmRpZGZhZGJubmSOK+SfVuIkEB6Yklq
	dmpqQWoRTB8TB6dUA6OM9ISbjJkr2Rkrf1dJ+a+TDTOSfv3hqkl8mcetqZZVbBosreZmXaZX
	LGcr8gi9f5/VXR5+1SXn6dOTfoWtbXJb7pR7/pecf5PhkfLRBqeJ/9Jez2q2DjVY1S3bmL5M
	cJExd1TpCY9PZdNFbH/tEL3r4/J588StXieeO/QdaXh+cl/oA1f1HCWW4oxEQy3mouJEAEiC
	qCkpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 05, 2015 3:01 PM, Zhang Rui wrote:
> On Mon, 2015-01-05 at 13:46 +0800, Aaron Lu wrote:
> > On 01/03/2015 09:04 AM, Jingoo Han wrote:
> > > On Wednesday, December 31, 2014 12:50 PM, Aaron Lu wrote:
> > >>
> > >> It is useful to get the backlight device's pointer and use it to set
> > >> backlight in some cases(the following patch will make use of it) so add
> > >> the two APIs and export them.
> > >>
> > >> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> > >
> > > Acked-by: Jingoo Han <jg1.han@samsung.com>
> >
> So Jingoo and Lee, will you take the first two patches, or you'd like me
> the take the whole patch set?

Hi Zhang Rui,

I would like you to take the whole patch set.
This is because 3rd patch makes the build error
without 1st & 2nd patches. Thank you.

Best regards,
Jingoo Han

> 
> thanks,
> rui
> > Thanks for the review!
> >
> > Regards,
> > Aaron
> >
> > >
> > > Best regards,
> > > Jingoo Han
> > >
> > >> ---
> > >>  drivers/video/backlight/backlight.c | 44 ++++++++++++++++++++++++-------------
> > >>  include/linux/backlight.h           |  2 ++
> > >>  2 files changed, 31 insertions(+), 15 deletions(-)
> > >>
> > >> diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
> > >> index bddc8b17a4d8..bea749329236 100644
> > >> --- a/drivers/video/backlight/backlight.c
> > >> +++ b/drivers/video/backlight/backlight.c
> > >> @@ -164,28 +164,19 @@ static ssize_t brightness_show(struct device *dev,
> > >>  	return sprintf(buf, "%d\n", bd->props.brightness);
> > >>  }
> > >>
> > >> -static ssize_t brightness_store(struct device *dev,
> > >> -		struct device_attribute *attr, const char *buf, size_t count)
> > >> +int backlight_device_set_brightness(struct backlight_device *bd, int brightness)
> > >>  {
> > >> -	int rc;
> > >> -	struct backlight_device *bd = to_backlight_device(dev);
> > >> -	unsigned long brightness;
> > >> -
> > >> -	rc = kstrtoul(buf, 0, &brightness);
> > >> -	if (rc)
> > >> -		return rc;
> > >> -
> > >> -	rc = -ENXIO;
> > >> +	int rc = -ENXIO;
> > >>
> > >>  	mutex_lock(&bd->ops_lock);
> > >>  	if (bd->ops) {
> > >>  		if (brightness > bd->props.max_brightness)
> > >>  			rc = -EINVAL;
> > >>  		else {
> > >> -			pr_debug("set brightness to %lu\n", brightness);
> > >> +			pr_debug("set brightness to %u\n", brightness);
> > >>  			bd->props.brightness = brightness;
> > >>  			backlight_update_status(bd);
> > >> -			rc = count;
> > >> +			rc = 0;
> > >>  		}
> > >>  	}
> > >>  	mutex_unlock(&bd->ops_lock);
> > >> @@ -194,6 +185,23 @@ static ssize_t brightness_store(struct device *dev,
> > >>
> > >>  	return rc;
> > >>  }
> > >> +EXPORT_SYMBOL(backlight_device_set_brightness);
> > >> +
> > >> +static ssize_t brightness_store(struct device *dev,
> > >> +		struct device_attribute *attr, const char *buf, size_t count)
> > >> +{
> > >> +	int rc;
> > >> +	struct backlight_device *bd = to_backlight_device(dev);
> > >> +	unsigned long brightness;
> > >> +
> > >> +	rc = kstrtoul(buf, 0, &brightness);
> > >> +	if (rc)
> > >> +		return rc;
> > >> +
> > >> +	rc = backlight_device_set_brightness(bd, brightness);
> > >> +
> > >> +	return rc ? rc : count;
> > >> +}
> > >>  static DEVICE_ATTR_RW(brightness);
> > >>
> > >>  static ssize_t type_show(struct device *dev, struct device_attribute *attr,
> > >> @@ -380,7 +388,7 @@ struct backlight_device *backlight_device_register(const char *name,
> > >>  }
> > >>  EXPORT_SYMBOL(backlight_device_register);
> > >>
> > >> -bool backlight_device_registered(enum backlight_type type)
> > >> +struct backlight_device *backlight_device_get_by_type(enum backlight_type type)
> > >>  {
> > >>  	bool found = false;
> > >>  	struct backlight_device *bd;
> > >> @@ -394,7 +402,13 @@ bool backlight_device_registered(enum backlight_type type)
> > >>  	}
> > >>  	mutex_unlock(&backlight_dev_list_mutex);
> > >>
> > >> -	return found;
> > >> +	return found ? bd : NULL;
> > >> +}
> > >> +EXPORT_SYMBOL(backlight_device_get_by_type);
> > >> +
> > >> +bool backlight_device_registered(enum backlight_type type)
> > >> +{
> > >> +	return backlight_device_get_by_type(type) ? true : false;
> > >>  }
> > >>  EXPORT_SYMBOL(backlight_device_registered);
> > >>
> > >> diff --git a/include/linux/backlight.h b/include/linux/backlight.h
> > >> index adb14a8616df..c59a020df3f8 100644
> > >> --- a/include/linux/backlight.h
> > >> +++ b/include/linux/backlight.h
> > >> @@ -140,6 +140,8 @@ extern void backlight_force_update(struct backlight_device *bd,
> > >>  extern bool backlight_device_registered(enum backlight_type type);
> > >>  extern int backlight_register_notifier(struct notifier_block *nb);
> > >>  extern int backlight_unregister_notifier(struct notifier_block *nb);
> > >> +extern struct backlight_device *backlight_device_get_by_type(enum backlight_type type);
> > >> +extern int backlight_device_set_brightness(struct backlight_device *bd, int brightness);
> > >>
> > >>  #define to_backlight_device(obj) container_of(obj, struct backlight_device, dev)
> > >>
> > >> --
> > >> 2.1.0
> > >
> >


