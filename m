Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaGIDMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbaGIDMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:12:33 -0400
Message-ID: <53BCB2E0.5000401@redhat.com>
Date: Tue, 08 Jul 2014 23:11:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 05/12] ARM: topology: use new cpu_power interface
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org> <1404144343-18720-6-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1404144343-18720-6-git-send-email-vincent.guittot@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/30/2014 12:05 PM, Vincent Guittot wrote:
> Use the new arch_scale_cpu_power in order to reflect the original
> capacity of a CPU instead of arch_scale_freq_power which is more
> linked to a scaling of the capacity linked to the frequency.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Acked-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTvLLgAAoJEM553pKExN6DZ40H/38CjOJQjRY4WZ+2UxlXSXfU
V7gcMwHCNIJvJQ0fG3IfxVacdlJsK8LsQMgPL5sYCeJpLKYrQHPIQ2dIdkmz2W9I
lcpr5dBq1AAB+PAbkywV2wtQBlDd0AMMQNrPqL6FdK92M4ML3iweJluA4qp0K1ip
AtZM90ku4SQ52RyQR3ePIb396CeT1TRqihDnpWxbcZt53DkqWW3SCVE68qL1SIEO
YKKlZyFXxLJDBZfM2kk90L8NPSmXzTa9xdsu+3CQKiyukqhgJoNe6J9E11CjlKBx
BQggFRRTliIUat7IGlkgcyWLhXhhMLrfoXJN/sEdrWG2T2rApnI4u2Q4PM02/zU=
=hHGQ
-----END PGP SIGNATURE-----
