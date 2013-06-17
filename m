Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab3FQALu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 20:11:50 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64383 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3FQALs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 20:11:48 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, dan.carpenter@oracle.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chad Williamson <chad@dahc.us>
Subject: [PATCH 1/3] Staging: silicom: move symbol exports beneath definitions in bpctl_mod.c
Date: Sun, 16 Jun 2013 19:05:23 -0500
Message-Id: <1371427525-6007-2-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371427525-6007-1-git-send-email-chad@dahc.us>
References: <1371427525-6007-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the EXPORT_SYMBOL macros in bpctl_mod.c beneath the definitions
they refer to, resolving checkpatch.pl warnings. While we're at it, use
EXPORT_SYMBOL rather than EXPORT_SYMBOL_NOVERS.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 91 ++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index a3b974b..4c8fb86 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -6878,59 +6878,69 @@ int is_bypass_sd(int ifindex)
 {
 	return is_bypass(get_dev_idx_p(ifindex));
 }
+EXPORT_SYMBOL(is_bypass_sd);
 
 int set_bypass_sd(int ifindex, int bypass_mode)
 {
 
 	return set_bypass_fn(get_dev_idx_p(ifindex), bypass_mode);
 }
+EXPORT_SYMBOL(set_bypass_sd);
 
 int get_bypass_sd(int ifindex)
 {
 
 	return get_bypass_fn(get_dev_idx_p(ifindex));
 }
+EXPORT_SYMBOL(get_bypass_sd);
 
 int get_bypass_change_sd(int ifindex)
 {
 
 	return get_bypass_change_fn(get_dev_idx_p(ifindex));
 }
+EXPORT_SYMBOL(get_bypass_change_sd);
 
 int set_dis_bypass_sd(int ifindex, int dis_param)
 {
 	return set_dis_bypass_fn(get_dev_idx_p(ifindex), dis_param);
 }
+EXPORT_SYMBOL(set_dis_bypass_sd);
 
 int get_dis_bypass_sd(int ifindex)
 {
 
 	return get_dis_bypass_fn(get_dev_idx_p(ifindex));
 }
+EXPORT_SYMBOL(get_dis_bypass_sd);
 
 int set_bypass_pwoff_sd(int ifindex, int bypass_mode)
 {
 	return set_bypass_pwoff_fn(get_dev_idx_p(ifindex), bypass_mode);
 
 }
+EXPORT_SYMBOL(set_bypass_pwoff_sd);
 
 int get_bypass_pwoff_sd(int ifindex)
 {
 	return get_bypass_pwoff_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_bypass_pwoff_sd);
 
 int set_bypass_pwup_sd(int ifindex, int bypass_mode)
 {
 	return set_bypass_pwup_fn(get_dev_idx_p(ifindex), bypass_mode);
 
 }
+EXPORT_SYMBOL(set_bypass_pwup_sd);
 
 int get_bypass_pwup_sd(int ifindex)
 {
 	return get_bypass_pwup_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_bypass_pwup_sd);
 
 int set_bypass_wd_sd(int if_index, int ms_timeout, int *ms_timeout_set)
 {
@@ -6939,136 +6949,159 @@ int set_bypass_wd_sd(int if_index, int ms_timeout, int *ms_timeout_set)
 	*ms_timeout_set = set_bypass_wd_fn(get_dev_idx_p(if_index), ms_timeout);
 	return 0;
 }
+EXPORT_SYMBOL(set_bypass_wd_sd);
 
 int get_bypass_wd_sd(int ifindex, int *timeout)
 {
 	return get_bypass_wd_fn(get_dev_idx_p(ifindex), timeout);
 
 }
+EXPORT_SYMBOL(get_bypass_wd_sd);
 
 int get_wd_expire_time_sd(int ifindex, int *time_left)
 {
 	return get_wd_expire_time_fn(get_dev_idx_p(ifindex), time_left);
 }
+EXPORT_SYMBOL(get_wd_expire_time_sd);
 
 int reset_bypass_wd_timer_sd(int ifindex)
 {
 	return reset_bypass_wd_timer_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(reset_bypass_wd_timer_sd);
 
 int get_wd_set_caps_sd(int ifindex)
 {
 	return get_wd_set_caps_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_wd_set_caps_sd);
 
 int set_std_nic_sd(int ifindex, int nic_mode)
 {
 	return set_std_nic_fn(get_dev_idx_p(ifindex), nic_mode);
 
 }
+EXPORT_SYMBOL(set_std_nic_sd);
 
 int get_std_nic_sd(int ifindex)
 {
 	return get_std_nic_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_std_nic_sd);
 
 int set_tap_sd(int ifindex, int tap_mode)
 {
 	return set_tap_fn(get_dev_idx_p(ifindex), tap_mode);
 
 }
+EXPORT_SYMBOL(set_tap_sd);
 
 int get_tap_sd(int ifindex)
 {
 	return get_tap_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_tap_sd);
 
 int set_tap_pwup_sd(int ifindex, int tap_mode)
 {
 	return set_tap_pwup_fn(get_dev_idx_p(ifindex), tap_mode);
 
 }
+EXPORT_SYMBOL(set_tap_pwup_sd);
 
 int get_tap_pwup_sd(int ifindex)
 {
 	return get_tap_pwup_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_tap_pwup_sd);
 
 int get_tap_change_sd(int ifindex)
 {
 	return get_tap_change_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_tap_change_sd);
 
 int set_dis_tap_sd(int ifindex, int dis_param)
 {
 	return set_dis_tap_fn(get_dev_idx_p(ifindex), dis_param);
 
 }
+EXPORT_SYMBOL(set_dis_tap_sd);
 
 int get_dis_tap_sd(int ifindex)
 {
 	return get_dis_tap_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_dis_tap_sd);
 
 int set_bp_disc_sd(int ifindex, int disc_mode)
 {
 	return set_disc_fn(get_dev_idx_p(ifindex), disc_mode);
 
 }
+EXPORT_SYMBOL(set_bp_disc_sd);
 
 int get_bp_disc_sd(int ifindex)
 {
 	return get_disc_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_bp_disc_sd);
 
 int set_bp_disc_pwup_sd(int ifindex, int disc_mode)
 {
 	return set_disc_pwup_fn(get_dev_idx_p(ifindex), disc_mode);
 
 }
+EXPORT_SYMBOL(set_bp_disc_pwup_sd);
 
 int get_bp_disc_pwup_sd(int ifindex)
 {
 	return get_disc_pwup_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_bp_disc_pwup_sd);
 
 int get_bp_disc_change_sd(int ifindex)
 {
 	return get_disc_change_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_bp_disc_change_sd);
 
 int set_bp_dis_disc_sd(int ifindex, int dis_param)
 {
 	return set_dis_disc_fn(get_dev_idx_p(ifindex), dis_param);
 
 }
+EXPORT_SYMBOL(set_bp_dis_disc_sd);
 
 int get_bp_dis_disc_sd(int ifindex)
 {
 	return get_dis_disc_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_bp_dis_disc_sd);
 
 int get_wd_exp_mode_sd(int ifindex)
 {
 	return get_wd_exp_mode_fn(get_dev_idx_p(ifindex));
 }
+EXPORT_SYMBOL(get_wd_exp_mode_sd);
 
 int set_wd_exp_mode_sd(int ifindex, int param)
 {
 	return set_wd_exp_mode_fn(get_dev_idx_p(ifindex), param);
 
 }
+EXPORT_SYMBOL(set_wd_exp_mode_sd);
 
 int reset_cont_sd(int ifindex)
 {
@@ -7081,35 +7114,41 @@ int set_tx_sd(int ifindex, int tx_state)
 	return set_tx_fn(get_dev_idx_p(ifindex), tx_state);
 
 }
+EXPORT_SYMBOL(set_tx_sd);
 
 int set_tpl_sd(int ifindex, int tpl_state)
 {
 	return set_tpl_fn(get_dev_idx_p(ifindex), tpl_state);
 
 }
+EXPORT_SYMBOL(set_tpl_sd);
 
 int set_bp_hw_reset_sd(int ifindex, int status)
 {
 	return set_bp_hw_reset_fn(get_dev_idx_p(ifindex), status);
 
 }
+EXPORT_SYMBOL(set_bp_hw_reset_sd);
 
 int set_wd_autoreset_sd(int ifindex, int param)
 {
 	return set_wd_autoreset_fn(get_dev_idx_p(ifindex), param);
 
 }
+EXPORT_SYMBOL(set_wd_autoreset_sd);
 
 int get_wd_autoreset_sd(int ifindex)
 {
 	return get_wd_autoreset_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_wd_autoreset_sd);
 
 int get_bypass_caps_sd(int ifindex)
 {
 	return get_bypass_caps_fn(get_dev_idx_p(ifindex));
 }
+EXPORT_SYMBOL(get_bypass_caps_sd);
 
 int get_bypass_slave_sd(int ifindex)
 {
@@ -7120,81 +7159,41 @@ int get_bypass_slave_sd(int ifindex)
 	return -1;
 
 }
+EXPORT_SYMBOL(get_bypass_slave_sd);
 
 int get_tx_sd(int ifindex)
 {
 	return get_tx_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_tx_sd);
 
 int get_tpl_sd(int ifindex)
 {
 	return get_tpl_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_tpl_sd);
 
 int get_bp_hw_reset_sd(int ifindex)
 {
 	return get_bp_hw_reset_fn(get_dev_idx_p(ifindex));
 
 }
+EXPORT_SYMBOL(get_bp_hw_reset_sd);
 
 int get_bypass_info_sd(int ifindex, struct bp_info *bp_info)
 {
 	return get_bypass_info_fn(get_dev_idx_p(ifindex), bp_info->prod_name, &bp_info->fw_ver);
 }
+EXPORT_SYMBOL(get_bypass_info_sd);
 
 int bp_if_scan_sd(void)
 {
 	if_scan_init();
 	return 0;
 }
-
-EXPORT_SYMBOL_NOVERS(is_bypass_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_slave_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_caps_sd);
-EXPORT_SYMBOL_NOVERS(get_wd_set_caps_sd);
-EXPORT_SYMBOL_NOVERS(set_bypass_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_change_sd);
-EXPORT_SYMBOL_NOVERS(set_dis_bypass_sd);
-EXPORT_SYMBOL_NOVERS(get_dis_bypass_sd);
-EXPORT_SYMBOL_NOVERS(set_bypass_pwoff_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_pwoff_sd);
-EXPORT_SYMBOL_NOVERS(set_bypass_pwup_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_pwup_sd);
-EXPORT_SYMBOL_NOVERS(set_bypass_wd_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_wd_sd);
-EXPORT_SYMBOL_NOVERS(get_wd_expire_time_sd);
-EXPORT_SYMBOL_NOVERS(reset_bypass_wd_timer_sd);
-EXPORT_SYMBOL_NOVERS(set_std_nic_sd);
-EXPORT_SYMBOL_NOVERS(get_std_nic_sd);
-EXPORT_SYMBOL_NOVERS(set_tx_sd);
-EXPORT_SYMBOL_NOVERS(get_tx_sd);
-EXPORT_SYMBOL_NOVERS(set_tpl_sd);
-EXPORT_SYMBOL_NOVERS(get_tpl_sd);
-EXPORT_SYMBOL_NOVERS(set_bp_hw_reset_sd);
-EXPORT_SYMBOL_NOVERS(get_bp_hw_reset_sd);
-EXPORT_SYMBOL_NOVERS(set_tap_sd);
-EXPORT_SYMBOL_NOVERS(get_tap_sd);
-EXPORT_SYMBOL_NOVERS(get_tap_change_sd);
-EXPORT_SYMBOL_NOVERS(set_dis_tap_sd);
-EXPORT_SYMBOL_NOVERS(get_dis_tap_sd);
-EXPORT_SYMBOL_NOVERS(set_tap_pwup_sd);
-EXPORT_SYMBOL_NOVERS(get_tap_pwup_sd);
-EXPORT_SYMBOL_NOVERS(set_wd_exp_mode_sd);
-EXPORT_SYMBOL_NOVERS(get_wd_exp_mode_sd);
-EXPORT_SYMBOL_NOVERS(set_wd_autoreset_sd);
-EXPORT_SYMBOL_NOVERS(get_wd_autoreset_sd);
-EXPORT_SYMBOL_NOVERS(set_bp_disc_sd);
-EXPORT_SYMBOL_NOVERS(get_bp_disc_sd);
-EXPORT_SYMBOL_NOVERS(get_bp_disc_change_sd);
-EXPORT_SYMBOL_NOVERS(set_bp_dis_disc_sd);
-EXPORT_SYMBOL_NOVERS(get_bp_dis_disc_sd);
-EXPORT_SYMBOL_NOVERS(set_bp_disc_pwup_sd);
-EXPORT_SYMBOL_NOVERS(get_bp_disc_pwup_sd);
-EXPORT_SYMBOL_NOVERS(get_bypass_info_sd);
-EXPORT_SYMBOL_NOVERS(bp_if_scan_sd);
+EXPORT_SYMBOL(bp_if_scan_sd);
 
 #define BP_PROC_DIR "bypass"
 
-- 
1.8.1.4

