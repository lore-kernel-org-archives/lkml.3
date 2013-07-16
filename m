Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3GPH26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:28:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3GPH24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:28:56 -0400
X-AuditID: cbfee61a-b7f646d000000f6b-a3-51e4f636cb1f
Date: Tue, 16 Jul 2013 09:28:47 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH v5 5/7] thermal:boost: Automatic enable/disable of BOOST
 feature
Message-id: <20130716092847.668e0b71@amdc308.digital.local>
In-reply-to: <20130711100832.48fe3b33@amdc308.digital.local>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-6-git-send-email-l.majewski@samsung.com>
 <20130711100832.48fe3b33@amdc308.digital.local>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xgK75tyeBBse/MVk8bfrBbtH38wqz
	xZr9P5ksOs8+YbZ484jb4s3DzYwWl3fNYbP43HuE0eJ24wo2i/6FvUwWTx72sVls/OrhwOOx
	eM9LJo871/aweayb9pbZo2/LKkaPR4tbGD2O39jO5PF5k1wAexSXTUpqTmZZapG+XQJXxvx9
	j1kL1rJUnP+7k6mBcSNzFyMnh4SAicTaQ2vZIGwxiQv31gPZXBxCAosYJTZsPgnltDNJvHz+
	kQWkikVAVWLLynnsIDabgJ7E57tPmboYOThEBPwl+luUQeqZBeYxSyzecQtsqrBAmMSqHd1g
	NbwC1hK3bmiBhDkFbCRuH7/ADjH/PaNEZ899sPn8ApIS7f9+QF1nJ3Hu0wawXbwCghI/Jt8D
	q2EW0JLYvK2JFcKWl9i85i3zBEbBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4Ah6JrWDcWWDxSFGAQ5GJR5eCZ4ngUKsiWXFlbmHGCU4mJVEeBM3AYV4UxIrq1KL
	8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwerZFu+oHBvj7TWBVLull
	9bWoFr2geUUt9aPfHX/TVZPPO3zgzpBZKjLr893ygIY9P3cmRzoLJH1vV7QXk3b6up2b2S/z
	zDq7n98WPXJ8r63mePDxu8hpV6b2fi0VPMF2XmajcIwQ1/Skr55/lnwV/ztdQub9koip+4Sm
	aJWbOx99HqG9QWyBEktxRqKhFnNRcSIAGp3+ppwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Zhang, Eduardo,

> Dear Zhang, Eduardo
> 
> Do you have any comments/feedback for me regarding this thermal
> framework related patch?
> 
> I've already received some feedback from Durga for this patch, but I
> think that maintainers are most welcome to express their opinion :-)
> 

Will you find time to give me the feedback about proposed changes to
thermal_core.c regarding the cpufreq boost support?

> Thanks in advance.
> 


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
