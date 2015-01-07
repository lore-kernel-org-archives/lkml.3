Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbbAGXZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:25:55 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36005 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbbAGXZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:25:54 -0500
To: Sam Bradshaw <sbradshaw@micron.com>
Cc: <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        <martin.petersen@oracle.com>
Subject: Re: [PATCH] block: pass correct seed to integrity metadata generation function
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <54936D1E.3020700@micron.com> <54ADBC6E.50301@micron.com>
Date: Wed, 07 Jan 2015 18:25:42 -0500
In-Reply-To: <54ADBC6E.50301@micron.com> (Sam Bradshaw's message of "Wed, 7
	Jan 2015 15:08:30 -0800")
Message-ID: <yq14ms25g21.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Sam" == Sam Bradshaw <sbradshaw@micron.com> writes:

Sam> Any particular objection to this patch?  It would be nice if the
Sam> kernel supported PI on block sizes other than just 512 bytes.

I never saw the patch. Did you CC: me on it?

-- 
Martin K. Petersen	Oracle Linux Engineering
