Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaCKNiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:38:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbaCKNiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:38:50 -0400
Date: Tue, 11 Mar 2014 14:38:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf, tools: Add jsmn `jasmine' JSON parser
Message-ID: <20140311133818.GF22678@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:31AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>

SNIP

> +/* Return line number of a jsmn token */
> +int json_line(char *map, jsmntok_t *t)
> +{
> +	return countchar(map, '\n', t->start) + 1;
> +}
> +
> +static const char *jsmn_types[] = {
> +	[JSMN_PRIMITIVE] = "primitive",
> +	[JSMN_ARRAY] = "array",
> +	[JSMN_OBJECT] = "object",
> +	[JSMN_STRING] = "string"
> +};
> +
> +#define NELE(x) (sizeof(x) / sizeof(*(x)))

use ARRAY_SIZE

jirka
