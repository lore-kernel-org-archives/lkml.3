Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbbABSvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:51:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51034 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbbABSva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:51:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Vivek Goyal <vgoyal@redhat.com>
References: <1420221379-4553-1-git-send-email-kuleshovmail@gmail.com>
Date: Fri, 02 Jan 2015 12:48:51 -0600
In-Reply-To: <1420221379-4553-1-git-send-email-kuleshovmail@gmail.com>
	(Alexander Kuleshov's message of "Fri, 2 Jan 2015 23:56:19 +0600")
Message-ID: <87vbkpvx0s.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19PZnRs6O173cTB1wCCbWBk5uMCa5d1i4M=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4991]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexander Kuleshov <kuleshovmail@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 215 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.7 (1.3%), b_tie_ro: 1.92 (0.9%), parse: 0.53 (0.2%),
	extract_message_metadata: 10 (4.5%), get_uri_detail_list: 0.65 (0.3%),
	tests_pri_-1000: 4.3 (2.0%), tests_pri_-950: 1.04 (0.5%), tests_pri_-900:
	0.80 (0.4%), tests_pri_-400: 13 (6.0%), check_bayes: 12 (5.6%), b_tokenize:
	3.2 (1.5%), b_tok_get_all: 4.2 (1.9%), b_comp_prob: 1.04 (0.5%),
	b_tok_touch_all: 1.71 (0.8%), b_finish: 0.54 (0.3%), tests_pri_0: 177 (82.3%),
	 tests_pri_500: 3.9 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] kexec: Fix a typo in comment
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Kuleshov <kuleshovmail@gmail.com> writes:

> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> ---
>  kernel/kexec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 9a8a01a..75a8b7e 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -444,7 +444,7 @@ arch_kexec_apply_relocations(const Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
>  }
>  
>  /*
> - * Free up memory used by kernel, initrd, and comand line. This is temporary
> + * Free up memory used by kernel, initrd, and command line. This is temporary
>   * memory allocation which is not needed any more after these buffers have
>   * been loaded into separate segments and have been copied elsewhere.
>   */
