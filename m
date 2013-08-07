Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3HGFJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 01:09:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57049 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3HGFJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 01:09:54 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5201D67A.9030601@jp.fujitsu.com>
Date: Wed, 7 Aug 2013 14:09:14 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 0/5] ACPI: acpi_bind_one()/acpi_unbind_one() cleanups
References: <3015032.qfOqgEVZKP@vostro.rjw.lan>
In-Reply-To: <3015032.qfOqgEVZKP@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/06 9:22), Rafael J. Wysocki wrote:
> Hi All,
>
> The following 5 patches clean up a little mess in acpi_bind_one() and
> acpi_unbind_one().  They are on top of current linux-next plus the patch
> at https://patchwork.kernel.org/patch/2839101/ .
>

> [1/5] Move duplicated code from acpi_bind_one()/acpi_unbind_one() to a separate
>        function.
> [2/5] Create symlinks in acpi_bind_one() under physical_node_lock.
> [3/5] Clean up inconsistent use of whitespace in acpi_bind_one()/acpi_unbind_one().
> [4/5] Use list_for_each_entry() to walk the list in acpi_unbind_one().
> [5/5] Clean up the error code path in acpi_unbind_one().

Acked-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu


>
> Thanks,
> Rafael
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


