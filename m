Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaIWNNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:13:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171AbaIWNNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:13:07 -0400
Message-ID: <542171E1.6090803@suse.cz>
Date: Tue, 23 Sep 2014 15:13:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>
CC: linux-kernel@vger.kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        mingo@kernel.org, sam@ravnborg.org, namhyung@kernel.org
Subject: Re: [PATCH 01/15] kbuild: add support of custom paths for "auto.conf*"
 files
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com> <1411422796-27049-2-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1411422796-27049-2-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-22 23:53, Alexis Berlemont wrote:
> +#define PATH_MAXLENGTH 4096
> +const char *conf_get_autoconfigdep_name(void)
> +{
> +	static char res_value[PATH_MAXLENGTH];

Please use the PATH_MAX macro instead.

Michal
