Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab3HASRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 14:17:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48954 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754046Ab3HASRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 14:17:42 -0400
Message-ID: <1375381061.2034.62.camel@joe-AO722>
Subject: Re: [PATCH 2/6] staging: ozwpan: Mark string as const
From: Joe Perches <joe@perches.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Date: Thu, 01 Aug 2013 11:17:41 -0700
In-Reply-To: <1375378806-17948-3-git-send-email-rupesh.gujare@atmel.com>
References: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
	 <1375378806-17948-3-git-send-email-rupesh.gujare@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-01 at 18:40 +0100, Rupesh Gujare wrote:
> Make sure that we mark const string so that it does not get modified.
[]
> diff --git a/drivers/staging/ozwpan/ozproto.h b/drivers/staging/ozwpan/ozproto.h
[]
> -void oz_binding_add(char *net_dev);
> -void oz_binding_remove(char *net_dev);
> +void oz_binding_add(const char *net_dev);
> +void oz_binding_remove(const char *net_dev);

const char *net_dev is a poor naming choice.
const char *name might be better.


