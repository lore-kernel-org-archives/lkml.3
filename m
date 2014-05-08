Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaEHBW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 21:22:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51947 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaEHBWx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 21:22:53 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-94-536adc6bc524
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Viresh Kumar'" <viresh.kumar@linaro.org>, "'Nishanth Menon'" <nm@ti.com>
Cc: "'Linux PM list'" <linux-pm@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>
References: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
 <CAOh2x=m8DzmLOGqL0E_seOZMuzU=O9vQuu-JEp+E5454RmfEXw@mail.gmail.com>
 <003901cf6664$e4e8d2a0$aeba77e0$@samsung.com>
 <CAKohpon7W726Hxj5OJ6SnmPz3gYhAeBRr1wS3SCa3F2hSLriLQ@mail.gmail.com>
 <5367946F.1030407@ti.com>
 <CAKohpon-KZpSJK7PxpLjZS7sVPcYraDxb4oJHN6dxSagD+F--Q@mail.gmail.com>
 <CAGo_u6pUVeMM9mqe5htvM1X_4pkRGEUVOA2ty4ZPfUyLcLZkrw@mail.gmail.com>
 <CAKohpokfcptseU6ST+e_GfU6poVJxXCXMeoYCvT65060v5GJYQ@mail.gmail.com>
 <003e01cf6984$fb950280$f2bf0780$@samsung.com>
 <CAGo_u6o0J_T_hnmDAiYpsDxe77iKPCjuWisZJfTjYYOVGJF96A@mail.gmail.com>
 <CAKohpo=qbj9w5=wWHEG=9c2spjbbhaDaXG+F-Lhe9QffV9sDbw@mail.gmail.com>
In-reply-to: <CAKohpo=qbj9w5=wWHEG=9c2spjbbhaDaXG+F-Lhe9QffV9sDbw@mail.gmail.com>
Subject: RE: [PATCH 1/3] PM / OPP: Add support for descending order for cpufreq
 table
Date: Thu, 08 May 2014 10:22:51 +0900
Message-id: <001501cf6a5c$07bc2520$17346f60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIqe0fjYa0YwQL6oKQ2dX7E8rarYwGe0UWzAg3L9n0CFbDXrQI73VqNAJ+GCpEBnU9akQFwpfDYAuYRDbQCG7oysAHyEw+TmerEgqA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t8zQ93sO1nBBi1/dS0aroZYzJqyl8ni
	8q45bBafe48wWrz5cZbJ4szpS6wWG796OLB7LN7zksnjzrU9bB5brrazePRtWcXocfzGdiaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDJObVvPUnBGoOLTueVsDYzzubsYOTgkBEwk2m+YdTFyApli
	EhfurWfrYuTiEBJYxijR8eIqC0zNpLcxEPFFjBIXZ15khnD+MUqc729iBulmE9CVOLZ+CyuI
	LSLgJfFj9QmwScwC9xkl/p97zQaSABrLKrHgZz2IzSkQLLHt3FGwZmGBcIk162YygdgsAqoS
	a1rfgw3iFbCU2Lj0CCOELSjxY/I9FhCbWUBdYtK8RcwQtrbEk3cXWCFeUJDYcfY1I8QRFRJX
	Tl1ng6gRkdj34h0jyEESAl/ZJXr2rGGEWCYg8W3yIag3ZSU2HWCGmCMpcXDFDZYJjBKzkKye
	hWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSBRP3MF4/4D1IcZkoPUT
	maVEk/OBSSCvJN7Q2MzIwtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZ
	ODilGhiPtZ5rSljVufDXgdYHTJ98ri9o3f/5RNbdLiP+x2GHBZ25Pp2aJi3/2UJ5ZtX8BPvy
	mNMmcWumbby7xXlz13mvhRYfZDcdvRZUqHbNzVKR99+uZe7Hd6w1nnS0Kl2CdTfn400dmWEx
	Jf0mUbxSv+Z+lqkvuTk/4N43FZ1lrDbbg17I1y0VilyvxFKckWioxVxUnAgA/PitqPgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t9jAd3sO1nBBssOaFo0XA2xmDVlL5PF
	5V1z2Cw+9x5htHjz4yyTxZnTl1gtNn71cGD3WLznJZPHnWt72Dy2XG1n8ejbsorR4/iN7Uwe
	nzfJBbBFNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl
	5gCdoqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOLVtPUvBGYGKT+eW
	szUwzufuYuTgkBAwkZj0NqaLkRPIFJO4cG89WxcjF4eQwCJGiYszLzJDOP8YJc73NzGDVLEJ
	6EocW7+FFcQWEfCS+LH6BFgHs8B9Ron/516zgSSEBJaxSiz4WQ9icwoES2w7dxSsWVggXGLN
	uplMIDaLgKrEmtb3YIN4BSwlNi49wghhC0r8mHyPBcRmFlCXmDRvETOErS3x5N0FVohTFSR2
	nH3NCHFEhcSVU9fZIGpEJPa9eMc4gVFoFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBCeJZ1I7GFc2WBxiFOBgVOLhzXDOChZiTSwrrsw9xCjBwawkwus/GSjE
	m5JYWZValB9fVJqTWnyIMRno04nMUqLJ+cAEllcSb2hsYmZkaWRmYWRibk6asJI474FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjPVt8zy+bpnU/WeJWrPICuFrIe/0zbr1VlZf+LnvmKfE/vXO
	8R0vMjZs03HPnbB3o95i1tIpxYuS9zV7q4X8Z0ty0+B9YJh1ri91qeyi3QaqvfcTdbYHTuA9
	WzFfY4qN2+oP+ccjFGVjH7rU1ojtEHU5x/fEt7A7vcO+5PnW8Fd1U/9P+ikgosRSnJFoqMVc
	VJwIAHKqPSRWAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @Jonghwan: Please consider doing this:
> - Don't play with the order of frequencies in table.
> - Instead initialize .driver_data filed with values that you need to write
> in the registers for all frequencies. i.e. 0 for highest frequency and
> FREQ_COUNT-1 for lowest one.

-> For that, I changed like this.
For initializing .driver_data, I changed dev_pm_opp_init_cpufreq_table function().


--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -622,12 +622,12 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
  * or in contexts where mutex locking cannot be used.
  */
 int dev_pm_opp_init_cpufreq_table(struct device *dev,
-                           struct cpufreq_frequency_table **table)
+               struct cpufreq_frequency_table **table, int order)
 {
        struct device_opp *dev_opp;
        struct dev_pm_opp *opp;
        struct cpufreq_frequency_table *freq_table;
-       int i = 0;
+       int i = 0, index = 0;

        /* Pretend as if I am an updater */
        mutex_lock(&dev_opp_list_lock);
@@ -649,16 +649,22 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
                return -ENOMEM;
        }

+       if (OPP_TABLE_ORDER_DESCENDING == order)
+               index = dev_pm_opp_get_opp_count(dev) - 1;
+
        list_for_each_entry(opp, &dev_opp->opp_list, node) {
                if (opp->available) {
-                       freq_table[i].driver_data = i;
+                       if (OPP_TABLE_ORDER_DESCENDING == order)
+                               freq_table[i].driver_data = index--;
+                       else
+                               freq_table[i].driver_data = index++;
                        freq_table[i].frequency = opp->rate / 1000;
                        i++;
                }
        }
        mutex_unlock(&dev_opp_list_lock);

-       freq_table[i].driver_data = i;
+       freq_table[i].driver_data = index;
        freq_table[i].frequency = CPUFREQ_TABLE_END;

        *table = &freq_table[0];


Is it acceptiable?

Thanks

Best Regards

