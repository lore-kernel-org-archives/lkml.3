Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbaJWSe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 14:34:57 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:52998 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaJWSez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 14:34:55 -0400
Message-ID: <54494A50.8050100@kernel.dk>
Date: Thu, 23 Oct 2014 12:34:56 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] scsi: remove unused label in sg_scsi_ioctl()
References: <1414088601-24249-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1414088601-24249-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 12:23 PM, Fabian Frederick wrote:
> label 'out' is unused since commit 374f8fdea4aa
> ("scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND")

This got fixed up yesterday.

-- 
Jens Axboe

