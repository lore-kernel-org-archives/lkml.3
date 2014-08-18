Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaHRLAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:00:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29913 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaHRLAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:00:04 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-59-53f1dcb154c4
Date: Mon, 18 Aug 2014 20:00:00 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v3 0/2] mfd: arizona: add support for INn_MODE
 register control using platform data
Message-id: <20140818200000.60302a15@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWyRsSkWHfjnY/BBjNe81pcuXiIyWLqwyds
	Fv+m3GC3uP7lOavF/CPnWC363yxktTj3aiWjxf2vRxktvl3pYLK4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweO2fdZfdYufwLm8emVZ1sHneu7WHz
	mHcy0OPlxN9sHn1bVjF6fN4kF8AdxWWTkpqTWZZapG+XwJWx7dxlpoLPrBV3+zYzNzBeYuli
	5OSQEDCROH72MzOELSZx4d56ti5GLg4hgaWMEtOvTYEruv6rjREiMZ1RYvLKLWAdQgL9TBJb
	rxiB2CwCqhJPlyxlBbHZBDQkvn/eDFYjAjT19pxOZpBmZoGfTBLNK56AJYQFiiT2XLvADmLz
	CrhKzP4whwlim43E6p3rmCHighI/Jt8Du4JZQEti87YmVghbXmLzmrdgQyUEZnJIrPn1jwXi
	CgGJb5MPAdkcQAlZiU0HoF6TlDi44gbLBEaRWUjGzkIydhaSsQsYmVcxiqYWJBcUJ6UXGesV
	J+YWl+al6yXn525iBEb06X/P+ncw3j1gfYgxGWjlRGYp0eR8YELIK4k3NDYzsjA1MTU2Mrc0
	I01YSZz3/sOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M+/oOzXa2Siud8tnbq9dIa+pH
	j42cKt8fSwSd9i7d/PCjXf/MWXM25ZV2+e+Tn/DeTlzk9PvjGpnGS3jurr/KsXLCgkhhFRVV
	41Qt0Ucak/7Nq1ooy9DBdvGpcTO3DuuhV21XS1Uz1Useeee/lv65nH3Fq/b8T5IcC/gtZnR8
	Kr2xV0h6jlGfEktxRqKhFnNRcSIAzMLP9P4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd2Ndz4GG/zazmpx5eIhJoupD5+w
	WfybcoPd4vqX56wW84+cY7Xof7OQ1eLcq5WMFve/HmW0+Halg8ni8q45bBZLr19kslj+9j+b
	xYTpa1ksWvceYbc43c3qwO+x4XMTm8eaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	Y97JQI+XE3+zefRtWcXo8XmTXAB3VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	whrGjG3nLjMVfGatuNu3mbmB8RJLFyMnh4SAicT1X22MELaYxIV769m6GLk4hASmM0pMXrmF
	GSQhJNDPJLH1ihGIzSKgKvF0yVJWEJtNQEPi++fNYDUiQM2353QygzQzC/xkkmhe8QQsISxQ
	JLHn2gV2EJtXwFVi9oc5TBDbbCRW71zHDBEXlPgx+R7YRcwCWhKbtzWxQtjyEpvXvGWewMg3
	C0nZLCRls5CULWBkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnC6eSe1gXNlgcYhRgINR
	iYfX4/WHYCHWxLLiytxDjBIczEoivNnnPwYL8aYkVlalFuXHF5XmpBYfYjQFensis5Rocj4w
	leWVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgtgulj4uCUamCUV21V98v7z3un
	QuXB06f16zn6p5rvPaWfUOB5aL7Pk4zYR0GXlyavnjPD6FFl1LGEVvVu6YM+Yhfqj4sWbwot
	9s9fsu2ozXXX6AtRC2Y6Pr5Roh32aLOo1+a5S1fcPn8n7ZtT5dvXS+zusCzOmcyT9ub12le9
	gi/SnMpmbblZ0cfY23N+yZsvSizFGYmGWsxFxYkAAnk3Py0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add support for INn_MODE register control using platform data.
Each input signal path can be configurated either as a Analogue or Digital using
the INn_MODE registers.

Changes for v3
- Change to use of_property_read_u32_array
- Fix a few typos
- Update commit message

Changes for v2
- Change to support
- Update commit message
- Update document content for more clarity

Inha Song (2):
  mfd: arizona: Add support for INn_Mode register control
  mfd: arizona: Update DT binding to support INn_MODE init_data

 Documentation/devicetree/bindings/mfd/arizona.txt | 8 ++++++++
 drivers/mfd/arizona-core.c                        | 8 +++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

-- 
2.0.0.390.gcb682f8
