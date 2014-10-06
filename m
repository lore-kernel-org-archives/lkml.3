Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaJFRpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:45:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42352 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbaJFRpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:45:23 -0400
Message-ID: <5432D4E7.3060804@zytor.com>
Date: Mon, 06 Oct 2014 10:44:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>, Vivek Goyal <vgoyal@redhat.com>
CC: Geoff Levand <geoff@infradead.org>, Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/5] kexec: Fix make headers_check
References: <cover.1408731991.git.geoff@infradead.org>	 <115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff@infradead.org>	 <20140825172234.GD14379@redhat.com> <1409402838.21896.99.camel@x220>
In-Reply-To: <1409402838.21896.99.camel@x220>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2014 05:47 AM, Paul Bolle wrote:
> 
> Obviously, this can only break compiling those libraries, or other
> users. It can't break already compiled binaries. Besides I don't think
> those libraries, etc actually exist. Maximilian mentioned klibc in
> January, but I wasn't able to find a version of klibc that cared about
> this prototype. No one pointed me at a version that does (or any other
> library, etc., for that matter).
> 

... and that would be a klibc bug and we'd just fix it.

	-hpa


