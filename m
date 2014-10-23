Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbaJWOJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:09:11 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35804 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaJWOJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:09:07 -0400
Message-ID: <54490C02.3000304@kernel.dk>
Date: Thu, 23 Oct 2014 08:09:06 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: remove unused label
References: <1414067559-1828-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1414067559-1828-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 06:32 AM, Sudip Mukherjee wrote:
> commit "374f8fdea4aabec8e918cf9951e51bfa4f570ea8" has fixed a problem by
> jumping to the correct label,but the previous incorrect label was not
> removed and it was still there in the code unused.

This one was fixed yesterday.

-- 
Jens Axboe

