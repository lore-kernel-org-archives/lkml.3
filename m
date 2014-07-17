Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaGQAvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:51:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8406 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbaGQAvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:51:04 -0400
X-AuditID: cbfee690-b7fb56d000003439-5e-53c71df15460
Date: Thu, 17 Jul 2014 00:50:57 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v3] PM / devfreq: Add possible_frequencies device attribute
To: Saravana Kannan <skannan@codeaurora.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140717005046080@myungjoo.ham
Msgkey: 20140717005046080@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140717005046080@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <725805840.101171405558256488.JavaMail.weblogic@epmlwas01c>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42JZI2JSovtR9niwQd9PPYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJVx8HMvS8EqpYobJzUaGLcodjFycggJqEssWnKSDcSWEDCROD15
	CwuELSZx4d56NoiapYwS9yZyw9T0HnvJ3sXIBRSfwyixvvM5O0iCRUBV4vefC4xdjBwcbAJ6
	EjM/J4OEhQX8JfacOgNWIiKQL9G78yYTSC+zQB+TxMr5j6AWKEms2fcKbDGvgKDEyZlPoI4A
	mjl5HiNEXE3i8vYJjBBxCYlZ0y+wQti8EjPan0LVy0lM+7qGGcKWljg/awMjzDOLvz+GivNL
	HLu9gwnkTpDeJ/eDYcbs3vwFGg4CElPPHIRq1ZL4c2gvVCufxJqFb1lgxuw6tZwZpvf+lrlM
	IDazgKLElO6H7BC2lsSXH/vY0L3FK+Au8XbzbaYJjMqzkKRmIWmfhaQdWc0CRpZVjKKpBckF
	xUnpRSZ6xYm5xaV56XrJ+bmbGIFJ4fS/ZxN2MN47YH2IMRkYJROZpUST84FJJa8k3tDYzMjC
	1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFVa7oRffu14/U33
	45lRjuasCcJ3Da3ezX2h9LewpDtZ+pGd2qfPz5V/cr24fermu3bdnjrfbxcuqV7POHYvurfX
	JbbboWKCY37AVVfPXX+iXjLcuvHJ++IayWkzNERn7PYq2775xymLfTXu8hdOTpWut/+a8NeL
	J2pmsVGIy+cH+oGSG0W5diqxFGckGmoxFxUnAgA6g4OUIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsVy+t/tft2PsseDDdo3qllc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIyD
	n3tZClYpVdw4qdHAuEWxi5GTQ0hAXWLRkpNsILaEgIlE77GX7BC2mMSFe+uB4lxANXMYJdZ3
	PgdLsAioSvz+c4Gxi5GDg01AT2Lm52SQsLCAv8SeU2fASkQE8iV6d95kAullFuhjklg5/xEb
	xDIliTX7XrGA2LwCghInZz5hgVgGNHPyPEaIuJrE5e0TGCHiEhKzpl9ghbB5JWa0P4Wql5OY
	9nUNM4QtLXF+1gZGmKMXf38MFeeXOHZ7BxPInSC9T+4Hw4zZvfkL1L8CElPPHIRq1ZL4c2gv
	VCufxJqFb1lgxuw6tZwZpvf+lrlMIDazgKLElO6H7BC2lsSXH/vY0L3FK+Au8XbzbaYJjHKz
	kKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpFSZ6xYm5xaV56XrJ+bmbGMHJ6dmSHYwNF6wPMQpw
	MCrx8Ca0HgsWYk0sK67MPcQowcGsJMLrynQ8WIg3JbGyKrUoP76oNCe1+BBjMjACJzJLiSbn
	AxNnXkm8obGxiZmJqaWJhYGpOWnCSuK8C24lBQkJpCeWpGanphakFsFsYeLglGpg3GdySj6o
	5aLL+ilv1d5YRwZHB6/LdY9ozMjNey7pyri28In5+xmOhZpOO5tsgjc2LE6wWfpM68I+pX1V
	Zg3331xU39+dqKXmm8k+v3/l/ttsS9y2zX05ecNvnpyf5ea/jr4I3vTgpI7DvqPNmz8pTF93
	rXmhl+PVp0cTV01K69W55727JkxMUImlOCPRUIu5qDgRAFfenZmSAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6H0pB7I000849

On Wed, Jul 16, 2014 at 12:01 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
> Some devices use freq_table instead of OPP. For those devices, the
> available_frequencies sysfs file shows up empty. So, add a
> possible_frequencies attribute/syfs file that list all the possible
> frequencies.
>
> For devices that use OPP, the output of this file will match
> available_frequencies. It may change in the future to show all OPP
> frequencies -- even the disabled ones.
>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>

Hi,


Please add a documentation entry for this new ABI having a little justification and usage included.

Plus, I am considering to move trans_stat along with this entry to somewhere such as .../stat/*
(you don't need to take care of this.)

Besides, as OPP seems becoming the standard as imagined when devfreq development started,
soon, devfreq may require OPP unless the devfreq device has continuous frequencies.

Cheers,
MyungJoo

> ---
>  drivers/devfreq/devfreq.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 9f90369..65eed38 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -994,6 +994,31 @@ static ssize_t available_frequencies_show(struct device *d,
>  }
>  static DEVICE_ATTR_RO(available_frequencies);
>
> +static ssize_t possible_frequencies_show(struct device *d,
> +                                         struct device_attribute *attr,
> +                                         char *buf)
> +{
> +       struct devfreq *df = to_devfreq(d);
> +       unsigned int i = 0;
> +       ssize_t count = 0;
> +
> +       if (!df->profile->freq_table)
> +               return available_frequencies_show(d, attr, buf);
> +
> +       for (i = 0; i < df->profile->max_state; i++)
> +               count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
> +                                  "%u ", df->profile->freq_table[i]);
> +
> +       /* Truncate the trailing space */
> +       if (count)
> +               count--;
> +
> +       count += sprintf(&buf[count], "\n");
> +
> +       return count;
> +}
> +static DEVICE_ATTR_RO(possible_frequencies);
> +
>  static ssize_t trans_stat_show(struct device *dev,
>                                struct device_attribute *attr, char *buf)
>  {
> @@ -1041,6 +1066,7 @@ static struct attribute *devfreq_attrs[] = {
>         &dev_attr_available_governors.attr,
>         &dev_attr_cur_freq.attr,
>         &dev_attr_available_frequencies.attr,
> +       &dev_attr_possible_frequencies.attr,
>         &dev_attr_target_freq.attr,
>         &dev_attr_polling_interval.attr,
>         &dev_attr_min_freq.attr,
> --
> 1.8.2.1
>
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung ElectronicsˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
