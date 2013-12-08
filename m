Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3LHLNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 06:13:13 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:62809 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846Ab3LHLNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 06:13:12 -0500
Message-ID: <1386501189.28599.5.camel@x220.thuisdomein>
Subject: Re: Regression with suspend resume
 5a87182aa21d6d5d306840feab9321818dd3e2a3
From: Paul Bolle <pebolle@tiscali.nl>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        LKML <linux-kernel@vger.kernel.org>, viresh.kumar@linaro.org,
        tianyu.lan@intel.com, jinchoi@broadcom.com
Date: Sun, 08 Dec 2013 12:13:09 +0100
In-Reply-To: <52A448F2.4010208@redhat.com>
References: <52A448F2.4010208@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Dec 2013 11:13:10.0409 (UTC) FILETIME=[7A980F90:01CEF406]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-08 at 11:24 +0100, Zdenek Kabelac wrote:
> I'm testing recent 3.13-rc kernel - and I've notice my Lenovo T61 is not able 
> to resume.  After bisect I've found commit:
> 
> 5a87182aa21d6d5d306840feab9321818dd3e2a3

That's "cpufreq: suspend governors on system suspend/hibernate".

> When I just revert this commit with 374b105797c3d4f29c685f3be535c35f5689b30e 
> (3.13-rc3)   suspend/resume works again.
> (I'm using  ondemand CPU governor)

Rafael just asked Linus to pull a revert of that commit (see
https://lkml.org/lkml/2013/12/7/126 ).


Paul Bolle

